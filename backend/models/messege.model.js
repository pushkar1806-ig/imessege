import mongoose from "mongoose";

const messegeSchema = new mongoose.Schema({
    senderId: {
        type: mongoose.Schema.Types.ObjectId,
        ref:"User",
        required: true,
    },
    receiverId: {
        type: mongoose.Schema.Types.ObjectId,
        ref:"User",
        required: true,
    },
    text:{
        type: String,
    },
    video: {
        type: String,
    },
    image: {
        type: String, 
    }
},{timestamps: true});

const Messege = mongoose.model("Messege",messegeSchema);

export default Messenge

