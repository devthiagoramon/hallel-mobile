import React, { ReactNode } from "react";
import { PressableProps } from "react-native";
import { ButtonHComponent, ButtonHTextComponent } from "./style";

interface ButtonHProps extends PressableProps {
    variant: "contained" | "outlined";
    color: "primary" | "primaryLight" | "secondary";
    children: "string" | ReactNode;
}

const ButtonH = ({ color, variant, ...props }: ButtonHProps) => {
    return (
        <ButtonHComponent $color={color} $variant={variant} {...props}>
            <ButtonHTextComponent $color={color}>
                {props.children}
            </ButtonHTextComponent>
        </ButtonHComponent>
    );
};

export default ButtonH;
