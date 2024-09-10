import AsyncStorage from "@react-native-async-storage/async-storage";

export const getTokenUser = async () => {
  try {
    const token = await AsyncStorage.getItem("token");
    return token || false;
  } catch (error) {
    throw new Error("Can't get user token");
  }
};
