import { Navigation } from "react-native-navigation";
import { Provider } from "react-redux";
import AuthScreen from "./src/screens/Auth/Auth";
import SharePlaceScreen from "./src/screens/SharePlace/SharePlace";
import FindPlaceScreen from "./src/screens/FindPlace/FindPlace";
import configureStore from "./src/store/configureStore";
// Register Screens

const store = configureStore();
Navigation.registerComponent(
  "awesome-places.AuthScreen",
  () => AuthScreen,
  store,
  Provider
);
Navigation.registerComponent(
  "awesome-places.SharePlaceScreen",
  () => SharePlaceScreen,
  store,
  Provider
);
Navigation.registerComponent(
  "awesome-places.FindPlaceScreen",
  () => FindPlaceScreen,
  store,
  Provider
);

// Start a App
Navigation.startSingleScreenApp({
  screen: {
    screen: "awesome-places.AuthScreen",
    title: "Login"
  }
});
