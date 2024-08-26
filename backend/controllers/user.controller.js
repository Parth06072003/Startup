import { response } from "express";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import { User } from "../models/user.model.js";
import { barber } from "../models/barber.model.js";


export const register = async (req, res) => {
  try {
    const { Username, Email, Password, Role, service, timeslot } = req.body;

    if (!Username || !Email || !Password || !Role) {
      return res.status(400).json({
        message: "Something is missing",
        success: false,
      });
    }

    const existingUserByEmail = await User.findOne({ Email });
    if (existingUserByEmail) {
      return res.status(400).json({
        message: "Email already exists",
        success: false,
      });
    }

    const existingUserByUsername = await User.findOne({ Username });
    if (existingUserByUsername) {
      return res.status(400).json({
        message: "Username already exists",
        success: false,
      });
    }

    const hashedPassword = await bcrypt.hash(Password, 10);


    if (Role === "Barber") {
      const newBarber = new barber({
        Username,
        Email,
        Password: hashedPassword,
      });
      await newBarber.save();
    } else if (Role === "User") {

      const newUser = new User({
        Username,
        Email,
        Password: hashedPassword,
        Service: service,
        TimeSlot:timeslot
      });
      await newUser.save();
    } else {
      return res.status(400).json({
        message: "Invalid role specified",
        success: false,
      });
    }

    return res.status(201).json({
      message: "Account created successfully",
      success: true,
    });

  } catch (error) {
    console.error("Error in registration:", error);
    return res.status(500).json({
      message: "Server error",
      success: false,
    });
  }
};

export const login = async (req, res) => {
  try {
    const { Username, Password, Role } = req.body;
    if (!Username || !Password || !Role) {
      return res.status(400).json({
        message: "Something Is Missing",
        success: false,
      });
    }

    let userOrbarber;
    if (Role === "Barber") {
      userOrbarber = await barber.findOne({ Username });
      if (!userOrbarber) {
        return res.status(400).json({
          message: "Barber Not Found",
          success: false,
        });
      }
    } else {
      userOrbarber = await User.findOne({ Username });
      if (!userOrbarber) {
        return res.status(400).json({
          message: "User Not Found",
          success: false,
        });
      }
    }

    const isPasswordMatch = await bcrypt.compare(Password, userOrbarber.Password);
    if (!isPasswordMatch) {
      return res.status(404).json({
        message: "Incorrect Password",
        success: false,
      });
    }

    const tokenData = {
      userID: userOrbarber._id,
    };

    const token = jwt.sign(tokenData, process.env.SECRET_KEY, {
      expiresIn: "1d",
    });

    return res
      .status(200)
      .cookie("token", token, {
        maxAge: 1 * 24 * 60 * 60 * 1000,
        httpOnly: true,
        sameSite: "strict",
      })
      .json({
        message: `Welcome Back ${userOrbarber.Username}`,
        user: {
          _id: userOrbarber._id,
          Username: userOrbarber.Username,
          Email: userOrbarber.Email,
          Role: userOrbarber.Role,
        },
        success: true,
      });
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      message: "Server Error",
      success: false,
    });
  }
};

export const logout = async (req, res) => {
  try {
    return res
      .status(200)
      .cookie("token", "", {
        maxAge: 0,
      })
      .json({
        message: "Logout Successfully",
        success: true,
      });
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      message: "Server Error",
      success: false,
    });
  }
};

export const getAllUsers = async (req, res) => {
  try {
    // Find users with at least one service having status 'pending'
    const users = await User.find({
      status:'pending' 
    });

    console.log(users);

    return res.status(200).json({
      message: "Users fetched successfully",
      success: true,
      data: users,
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      message: "Server Error",
      success: false,
    });
  }
};
