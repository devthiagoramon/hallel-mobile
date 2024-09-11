import styled from "styled-components/native";

export const LabelInputHComponent = styled.Text<{
  $color: "white" | "black";
}>`
  color: ${(props) =>
    props.$color === "white"
      ? props.theme.light.whiteText
      : props.theme.light.text};
  font-size: 18px;
  font-weight: 600;
`;
