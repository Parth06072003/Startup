import express, { urlencoded } from "express";
import cookieParser from "cookie-parser";
import cors from "cors";
import connectDB from "./utils/db.js";
import userRoute from "./routes/user.route.js";
import dotenv from "dotenv";

dotenv.config({});

const app=express()
const port=3000
const HOST = '192.168.0.102';

const corsOptions={
    origin:"http://192.168.0.102",
    credentials:true
}
app.use(cors(corsOptions))

app.use(express.json());//to pass the data in json format 
app.use(express.urlencoded({extended:true}));
app.use(cookieParser());

app.use("/user",userRoute);

app.listen(port,"0.0.0.0",()=>{
    connectDB();
    console.log("Port Running On "+HOST +" "+port);
    
})