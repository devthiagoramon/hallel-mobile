import styled from "styled-components/native";

export const MainPageContainer = styled.View`
  flex: 1;
  background-color: #033017;
`;

export const MainPageImageContainer = styled.View`
  margin-top: 25%;
  width: 100%;
  height: 129px;
  align-items: center;
`;

export const MainPageImage = styled.Image`
  width: 200px;
  height: 129px;
`;

export const MainPageBottomContainer = styled.View`
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 35%;
  border-radius: 24px 24px 0 0;
  background-color: #06612e;
  padding: 0 16px 16px 24px;
`;

export const MainPageBottomContainerTitle = styled.Text`
  font-size: 36px;
  font-weight: bold;
  color: ${(props) => props.theme.light.whiteText};
  margin-top: 30px;
`;

export const MainPageBottomContainerButtons = styled.View`
  margin-top: 36px;
  row-gap: 24px;
  width: 100%;
  height: 100%;
`;
