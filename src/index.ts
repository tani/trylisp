import * as biwa from "./biwa";
import * as jscl from "./jscl";

const runner = {
    biwa,
    jscl,
}

Object.defineProperty(window, "runner", runner);