import BiwaScheme from "biwascheme/release/biwascheme.mjs";

export async function run(code: string): Promise<string> {
    const sos = new BiwaScheme.Port.StringOutput() as any;
    BiwaScheme.Port.current_output = sos;
    BiwaScheme.Port.current_error = sos;
    const interp = new BiwaScheme.Interpreter();
    try {
        interp.evaluate(code);
        return Promise.resolve(sos.output_string());
    } catch (err) {
        return Promise.resolve(err.toString());
    }
}