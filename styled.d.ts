import "styled-components/native";
import { ThemeType } from "./components/AppTheme";

declare module "styled-components/native" {
  export interface DefaultTheme extends ThemeType {}
}
