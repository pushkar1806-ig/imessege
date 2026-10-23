import mongoose from "mongoose";

export async function connectDB() {
    try {
        const mongoUri = process.env.MONGO_URL;
        
        if (!mongoUri) {
            throw new Error("MONGO_URL is not defined in environment variables");
        }

        const conn = await mongoose.connect(mongoUri);
        console.log(`MongoDB connected: ${conn.connection.host}`);
    } catch (error) {
        console.error("Error connecting to MongoDB:", error.message);
        // process.exit(1); <-- Removed this so the app doesn't crash!
    }
}