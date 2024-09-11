import React, { useState } from "react";
import { TextInput, TextInputProps } from "react-native-paper";

interface PasswordInputPaperProps extends TextInputProps {
    iconColor?: string

}

const PasswordInputPaper = (props: PasswordInputPaperProps) => {
    const [showPassword, setShowPassword] = useState<boolean>(false);

    return (
        <TextInput
            right={
                <TextInput.Icon
                    onPress={() => setShowPassword(!showPassword)}
                    color={props.iconColor}
                    icon={showPassword ? "eye-off" : "eye"}
                />
            }
            secureTextEntry={!showPassword}
            {...props}
        />
    );
};

export default PasswordInputPaper;
