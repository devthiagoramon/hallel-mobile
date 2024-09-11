import styled from "styled-components/native";

export const LoginSignUpContainer = styled.View`
  flex: 1;
  background-color: #033017;
`;
export const LoginSignUpContainerBackIcon = styled.View`
  position: absolute;
  top: 30px;
`;

export const LoginSignUpImageContainer = styled.View`
  margin-top: 20%;
  width: 100%;
  height: 94px;
  align-items: center;
`;

export const LoginSignUpImage = styled.Image`
  width: 145px;
  height: 100%;
`;

export const LoginSignUpFormsContainer = styled.View`
  padding: 16px;
  width: 100%;
  margin-top: 40px;
`;

export const LoginSignUpForms = styled.View`
  row-gap: 24px;
  width: 100%;
`;
export const LoginSignUpFormsTitle = styled.Text`
  font-size: 24px;
  font-weight: bold;
  color: ${(props) => props.theme.light.whiteText};
  text-transform: uppercase;
`;

export const LoginForgetPasswordText = styled.Text`
  font-size: 16px;
  margin-top: 8px;
  align-self: flex-end;
  font-weight: 400;
  color: ${(props) => props.theme.light.secondary};
`;

export const LoginSignUpButtonContainer = styled.View`
  width: 100%;
  margin-top: 24px;
  align-items: center;
`;
