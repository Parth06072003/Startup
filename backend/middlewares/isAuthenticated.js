import jwt from "jsonwebtoken";

const isAuthenticated = async (req, res, next) => {
  try {
    const token = req.cookies.token;
    if (!token) {
      console.log("Token is missing");
      return res.status(401).json({
        message: "User not Authenticated",
        success: false,
      });
    }
    const decode = jwt.verify(token, process.env.SECRET_KEY);
    if (!decode) {
      console.log("Token verification failed");
      return res.status(401).json({
        message: "Invalid Token",
        success: false,
      });
    }
    req.id = decode.userID;
    next();
  } catch (error) {
    console.error("Error in isAuthenticated middleware:", error);
    return res.status(500).json({
      message: "Internal Server Error",
      success: false,
    });
  }
};

export default isAuthenticated;
