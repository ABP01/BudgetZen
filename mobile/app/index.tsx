import { Text, View, StyleSheet } from "react-native";
import {Link} from "expo-router";
import { Image } from "expo-image";

export default function Index() {
  return (
    <View>
    <Text>Welcome to the BudgetZen App!</Text>
    </View>
  )
}

const styles = StyleSheet.create({
  container: {
    backgroundColor: "purple"
  }
})