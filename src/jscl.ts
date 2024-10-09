import JSCL from "jscl";

export async function run(code: string): Promise<string> {
    const fullCode = `
        (let* ((sos (make-string-output-stream))
               (*standard-output* sos)
               (*error-output* sos)
               (*trace-output* sos))
          ${code}
          (get-output-stream-string sos))
    `;
    try {
        return Promise.resolve(JSCL.evaluateString(fullCode)); 
    } catch (err) {
        return Promise.resolve(err.toString());
    }
}