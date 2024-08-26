import { User } from "../models/user.model.js";

export const updateStatus = async (req, res) => {
    try {
        const {Username,status} =req.body;
        console.log(Username);
        
      const user = await User.findOne({
        Username : Username 
      });
      console.log(user);
      
      user.status =status;
      console.log(user);
  
      await user.save();
      return res.status(200).json({
        message: "Users Status Updated successfully",
        success: true
      });
    } catch (error) {
      console.error(error);
      return res.status(500).json({
        message: "Server Error",
        success: false,
      });
    }
  };
  