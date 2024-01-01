import bcrypt from 'bcryptjs';
import { createInterface } from 'readline';
import Arguments from './utils/Argument.mjs';

// Hash password using bcryptjs
// Default salt is 10
// Usage:
// node generate_psw.msj --psw=foo --salt=10

const args = new Arguments().getArgs();

(async () => {
    const psw =
        args.psw ??
        (await (async () => {
            const promise = new Promise(resolve => {
                const readline = createInterface({
                    input: process.stdin,
                    output: process.stdout,
                });

                readline.question('Password: ', psw => {
                    readline.close();
                    resolve(psw);
                });
            });

            return await promise;
        })());

    const salt = await bcrypt.genSalt(args?.salt ? Number(args.salt) : 10);
    const hash = await bcrypt.hash(psw, salt);

    console.log();
    console.log('Password:');
    console.log(psw);
    console.log();
    console.log('Hashed password:');
    console.log('\x1b[42m\x1b[37m%s\x1b[0m', hash);
    console.log();
})();
