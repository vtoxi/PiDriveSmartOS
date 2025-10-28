#!/usr/bin/env python3
"""
PiDriveSmartOS - OBD-II Service Daemon

Reads vehicle data from CAN bus via SocketCAN and exposes via DBus.
Supports SAE J1979 OBD-II protocol.

Copyright (c) 2024 PiDriveSmartOS Contributors
Licensed under Apache 2.0
"""

import sys
import time
import signal
import logging
import asyncio
from typing import Dict, List, Optional

import can
import dbus
import dbus.service
import dbus.mainloop.glib
from gi.repository import GLib

# OBD-II PID definitions (SAE J1979)
OBD_PIDS = {
    0x0C: {'name': 'rpm', 'formula': lambda a, b: ((a * 256) + b) / 4, 'unit': 'rpm'},
    0x0D: {'name': 'speed', 'formula': lambda a: a, 'unit': 'km/h'},
    0x2F: {'name': 'fuel_level', 'formula': lambda a: (a * 100) / 255, 'unit': '%'},
    0x05: {'name': 'engine_temp', 'formula': lambda a: a - 40, 'unit': '°C'},
    0x42: {'name': 'battery_voltage', 'formula': lambda a, b: ((a * 256) + b) / 1000, 'unit': 'V'},
    0x11: {'name': 'throttle_position', 'formula': lambda a: (a * 100) / 255, 'unit': '%'},
    0x10: {'name': 'maf', 'formula': lambda a, b: ((a * 256) + b) / 100, 'unit': 'g/s'},
}

# DBus service constants
DBUS_SERVICE_NAME = "org.pidrive.obd"
DBUS_OBJECT_PATH = "/org/pidrive/obd"
DBUS_INTERFACE_NAME = "org.pidrive.obd.VehicleData"


class OBDService(dbus.service.Object):
    """DBus service for exposing OBD-II data"""
    
    def __init__(self, bus_name):
        super().__init__(bus_name, DBUS_OBJECT_PATH)
        self.logger = logging.getLogger(__name__)
        self.can_bus: Optional[can.Bus] = None
        self.vehicle_data: Dict[str, float] = {}
        self.dtcs: List[str] = []
        self.running = False
        
    def start(self):
        """Start the OBD service"""
        self.logger.info("Starting OBD service...")
        
        try:
            # Initialize SocketCAN interface
            self.can_bus = can.Bus(
                channel='can0',
                bustype='socketcan',
                receive_own_messages=False
            )
            self.logger.info("Connected to CAN bus: can0")
            
            self.running = True
            
            # Start background task to read CAN messages
            GLib.timeout_add(100, self._poll_can_bus)  # Poll every 100ms
            
            # Query OBD PIDs periodically
            GLib.timeout_add(500, self._query_obd_pids)  # Every 500ms
            
        except Exception as e:
            self.logger.error(f"Failed to start OBD service: {e}")
            self.ErrorOccurred(str(e))
            raise
    
    def stop(self):
        """Stop the OBD service"""
        self.logger.info("Stopping OBD service...")
        self.running = False
        
        if self.can_bus:
            self.can_bus.shutdown()
            self.can_bus = None
    
    def _poll_can_bus(self) -> bool:
        """Poll CAN bus for messages (non-blocking)"""
        if not self.running or not self.can_bus:
            return False
        
        try:
            # Non-blocking read with timeout
            msg = self.can_bus.recv(timeout=0.01)
            
            if msg:
                self._process_can_message(msg)
        
        except Exception as e:
            self.logger.error(f"CAN bus error: {e}")
        
        return True  # Continue polling
    
    def _query_obd_pids(self) -> bool:
        """Query OBD-II PIDs via CAN"""
        if not self.running or not self.can_bus:
            return False
        
        try:
            # Query common PIDs
            for pid in [0x0C, 0x0D, 0x2F, 0x05]:  # RPM, Speed, Fuel, Temp
                self._send_obd_request(pid)
        
        except Exception as e:
            self.logger.error(f"OBD query error: {e}")
        
        return True  # Continue querying
    
    def _send_obd_request(self, pid: int):
        """Send OBD-II request via CAN"""
        # Standard OBD-II request format (Mode 01, query PID)
        data = [0x02, 0x01, pid, 0x00, 0x00, 0x00, 0x00, 0x00]
        
        msg = can.Message(
            arbitration_id=0x7DF,  # OBD functional address
            data=data,
            is_extended_id=False
        )
        
        try:
            self.can_bus.send(msg)
        except Exception as e:
            self.logger.error(f"Failed to send OBD request for PID {pid:02X}: {e}")
    
    def _process_can_message(self, msg: can.Message):
        """Process incoming CAN message"""
        # OBD-II responses are on IDs 0x7E8 - 0x7EF
        if 0x7E8 <= msg.arbitration_id <= 0x7EF:
            self._decode_obd_response(msg)
    
    def _decode_obd_response(self, msg: can.Message):
        """Decode OBD-II response"""
        data = msg.data
        
        # Check if it's a valid OBD response (Mode 41 = response to Mode 01)
        if len(data) >= 3 and data[1] == 0x41:
            pid = data[2]
            
            if pid in OBD_PIDS:
                pid_info = OBD_PIDS[pid]
                
                try:
                    # Extract data bytes
                    if 'formula' in pid_info:
                        formula = pid_info['formula']
                        
                        # Different PIDs have different data lengths
                        if len(data) >= 4:
                            value = formula(data[3]) if formula.__code__.co_argcount == 1 else \
                                    formula(data[3], data[4])
                            
                            # Update vehicle data
                            self.vehicle_data[pid_info['name']] = value
                            
                            # Emit DBus signal with updated data
                            self.VehicleDataUpdated(self.vehicle_data)
                            
                            self.logger.debug(f"{pid_info['name']}: {value} {pid_info['unit']}")
                
                except Exception as e:
                    self.logger.error(f"Error decoding PID {pid:02X}: {e}")
    
    # DBus Methods
    
    @dbus.service.method(DBUS_INTERFACE_NAME, out_signature='a{sd}')
    def GetVehicleData(self) -> Dict[str, float]:
        """Get current vehicle data (DBus method)"""
        return self.vehicle_data
    
    @dbus.service.method(DBUS_INTERFACE_NAME, out_signature='as')
    def GetDTCs(self) -> List[str]:
        """Get diagnostic trouble codes (DBus method)"""
        # Query DTCs via CAN (Mode 03)
        self._query_dtcs()
        return self.dtcs
    
    @dbus.service.method(DBUS_INTERFACE_NAME, out_signature='b')
    def ClearDTCs(self) -> bool:
        """Clear diagnostic trouble codes (DBus method)"""
        try:
            # Send Mode 04 (Clear DTCs) request
            data = [0x01, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
            msg = can.Message(arbitration_id=0x7DF, data=data, is_extended_id=False)
            self.can_bus.send(msg)
            
            self.dtcs.clear()
            self.logger.info("DTCs cleared")
            return True
        
        except Exception as e:
            self.logger.error(f"Failed to clear DTCs: {e}")
            return False
    
    @dbus.service.method(DBUS_INTERFACE_NAME, in_signature='i')
    def SetUpdateInterval(self, interval_ms: int):
        """Set update interval in milliseconds (DBus method)"""
        # Not implemented yet
        pass
    
    def _query_dtcs(self):
        """Query DTCs via CAN (Mode 03)"""
        try:
            data = [0x01, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
            msg = can.Message(arbitration_id=0x7DF, data=data, is_extended_id=False)
            self.can_bus.send(msg)
            
            # Wait for response and parse
            # (Simplified - real implementation would wait for Mode 43 response)
            time.sleep(0.1)
        
        except Exception as e:
            self.logger.error(f"Failed to query DTCs: {e}")
    
    # DBus Signals
    
    @dbus.service.signal(DBUS_INTERFACE_NAME, signature='a{sd}')
    def VehicleDataUpdated(self, data: Dict[str, float]):
        """Signal emitted when vehicle data is updated"""
        pass
    
    @dbus.service.signal(DBUS_INTERFACE_NAME, signature='s')
    def ErrorOccurred(self, error: str):
        """Signal emitted when an error occurs"""
        pass


def signal_handler(sig, frame):
    """Handle Ctrl+C gracefully"""
    logging.info("Received signal to terminate, shutting down...")
    loop.quit()


if __name__ == "__main__":
    # Setup logging
    logging.basicConfig(
        level=logging.INFO,
        format='[%(asctime)s] [%(levelname)s] %(name)s: %(message)s',
        handlers=[
            logging.StreamHandler(sys.stdout),
            logging.FileHandler('/var/log/pidrive/obd.log')
        ]
    )
    
    logger = logging.getLogger(__name__)
    logger.info("PiDriveSmartOS OBD Service starting...")
    
    # Initialize DBus
    dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)
    
    try:
        bus = dbus.SystemBus()
        name = dbus.service.BusName(DBUS_SERVICE_NAME, bus)
        service = OBDService(name)
        
        # Start service
        service.start()
        
        # Setup signal handler for graceful shutdown
        signal.signal(signal.SIGINT, signal_handler)
        signal.signal(signal.SIGTERM, signal_handler)
        
        # Run main loop
        loop = GLib.MainLoop()
        logger.info("OBD Service running, waiting for requests...")
        loop.run()
        
        # Cleanup
        service.stop()
        logger.info("OBD Service stopped")
    
    except Exception as e:
        logger.error(f"Fatal error: {e}", exc_info=True)
        sys.exit(1)

