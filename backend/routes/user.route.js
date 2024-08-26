import { updateStatus } from '../controllers/apllication.controller.js';
import { findBarber, updateTimeSlot } from '../controllers/barber.controller.js';
import { getAllUsers, login, register } from '../controllers/user.controller.js';
import express from 'express'; 

const router =express.Router()

router.route('/login').post(login)
router.route('/register').post(register)
router.route('/getallUser').get(getAllUsers)
router.route('/updatetimeslot').post(updateTimeSlot)
router.route('/updateStatus').post(updateStatus)
router.route('/findBarber').post(findBarber)



export default router