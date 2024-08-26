import mongoose from "mongoose";

const allTimeSlots = [
  "9:00", "9:30", "10:00", "10:30", "11:00",
  "11:30", "12:00", "12:30", "13:00", "13:30",
  "14:00", "14:30", "15:00", "15:30", "16:00",
  "16:30", "17:00", "17:30", "18:00", "18:30",
  "19:00", "19:30", "20:00",
];
const createDefaultTimeSlots = () => {
  const timeSlotsMap = {};
  allTimeSlots.forEach(slot => {
    timeSlotsMap[slot] = false;
  });
  return timeSlotsMap;
};

const barberSchema = new mongoose.Schema({
  Username: {
    type: String,
    required: true,
  },
  Email: {
    type: String,
    required: true,
    unique: true,
  },
  Password: {
    type: String,
    required: true,
  },
  timeSlots: {
    type: Map,
    of: Boolean,
    default: createDefaultTimeSlots,
  },
});

export const barber = mongoose.model("Barber", barberSchema);
