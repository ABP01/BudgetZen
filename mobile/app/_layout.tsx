import { Slot } from "expo-router";
import SafeScreen from "@/components/SafeScreen";
import { StatusBar } from "expo-status-bar";

export default function RootLayout() {
  return (
      <SafeScreen>
        <Slot />
      </SafeScreen>
  );
}