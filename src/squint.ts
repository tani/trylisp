import { compileString } from 'squint-cljs';
import * as squint_core from 'squint-cljs/core.js';

export async function run(code: string): Promise<string> {
  const jsCode = compileString(code, { context: "statement", "elide-imports": true });
  const jsFunc = Function('squint_core', `${jsCode}`);
  let output = "";
  const write = (...args) => { output += args.map(arg => arg.toString()).join(" ") + "\n"; };
  const ConsoleLog = console.log;
  const ConsoleInfo = console.info;
  const ConsoleWarn = console.warn;
  const ConsoleError = console.error;
  console.log = write;
  console.info = write;
  console.warn = write;
  console.error = write;
  try {
    jsFunc(squint_core);
  } catch(err) {
    output = err.toString();
  } finally {
    console.log = ConsoleLog;
    console.warn = ConsoleWarn;
    console.info = ConsoleInfo;
    console.error = ConsoleError;
  }
  return Promise.resolve(output);
}
