import axios from "axios";
import AsyncStorageLib from "@react-native-async-storage/async-storage";
const instance = axios.create({
  baseURL: "http://localhost:3000",
});

instance.interceptors.request.use(
    async (config) => {
        const token = await AsyncStorageLib.getItem('token')
        if (token) {
            config.headers.Authorization = `Bearer ${token}`
        }
        return config;
    },
    (err) => {
        return Promise.reject(err);
    }
);

export default instance;