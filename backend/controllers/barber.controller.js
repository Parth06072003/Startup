import { barber } from "../models/barber.model.js";

export const updateTimeSlot = async (req, res) => {
    const { username, timeSlot } = req.body;
  
    try {
      const bab = await barber.findOne({ Username: username });
  
      if (!bab) {
        return res.status(404).json({
          success: false,
          message: 'Barber not found',
        });
      }
      if (!bab.timeSlots.has(timeSlot)) {
        return res.status(400).json({
          success: false,
          message: 'Invalid time slot',
        });
      }
      if (bab.timeSlots.get(timeSlot)) {
        return res.status(400).json({
          success: false,
          message: 'Time slot is already booked',
        });
      }

      bab.timeSlots.set(timeSlot, true);
      await bab.save();
  
      return res.status(200).json({
        success: true,
        message: 'Time slot successfully booked',
      });
    } catch (error) {
      console.error('Error updating time slot:', error);
      return res.status(500).json({
        success: false,
        message: 'Server error',
      });
    }
  };
  

  export const findBarber = async (req, res) => {
    
    try {
      const { Username } = req.body;
      
      const bab = await barber.findOne({ Username: Username });
      console.log(bab);
      
  
      if (!bab) {
        return res.status(404).json({
          success: false,
          message: 'Barber not found',
        });
      }
      return res.status(200).json({
        success: true,
        message: 'Success',
        data: bab.timeSlots
      });
    } catch (error) {
      console.error('Error', error);
      return res.status(500).json({
        success: false,
        message: 'Server error',
      });
    }
  };  