import styled from "styled-components/native";

export const ButtonHComponent = styled.Pressable<{
  $variant: "contained" | "outlined";
  $color: "primary" | "primaryLight" | "secondary" | "success" | "error";
}>`
  width: 100%;
  height: 55px;
  border-radius: 12px;
  justify-content: center;
  align-items: center;
  background-color: ${(props) => {
    switch (props.$color) {
      case "primary":
        return props.theme.light.secondary;
      case "primaryLight":
        return props.theme.light.secondaryLigth;
      case "secondary":
        return props.theme.light.principal;
      case "success":
        return props.theme.light.success;
      case "error":
        return props.theme.light.error;
    }
  }};
`;

export const ButtonHTextComponent = styled.Text<{
  $color: "primary" | "primaryLight" | "secondary" | "success" | "error";
}>`
  color: ${(props) => {
    switch (props.$color) {
      case "primary":
        return props.theme.light.whiteText;
      case "primaryLight":
        return props.theme.light.text;
      case "secondary":
        return props.theme.light.whiteText;
      case "success":
        return props.theme.light.whiteText;
      case "error":
        return props.theme.light.whiteText;
    }
  }};
  text-transform: uppercase;
  font-size: 18px;
  font-weight: bold;
`;
