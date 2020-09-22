import svelte from 'rollup-plugin-svelte';
import scss from 'rollup-plugin-scss';
import coffeescript from 'rollup-plugin-coffee-script';
import sveltePreprocess from 'svelte-preprocess';
import resolve from '@rollup/plugin-node-resolve';
import commonjs from '@rollup/plugin-commonjs';
import livereload from 'rollup-plugin-livereload';
import { terser } from 'rollup-plugin-terser';

const production = !process.env.ROLLUP_WATCH;

function serve() {
	let server;
	
	function toExit() {
		if (server) server.kill(0);
	}

	return {
		writeBundle() {
			if (server) return;
			server = require('child_process').spawn('npm', ['run', 'start', '--', '--dev'], {
				stdio: ['ignore', 'inherit', 'inherit'],
				shell: true
			});

			process.on('SIGTERM', toExit);
			process.on('exit', toExit);
		}
	};
}

export default {
	input: 'src/main.js',
	output: {
		sourcemap: true,
		format: 'iife',
		name: 'app',
		file: 'public/build/bundle.js'
	},
  plugins: [
    coffeescript(),
    scss({
      output: 'public/style.css',
      watch: 'src/styles',
      indentedSyntax: true
    }),
		svelte({
      dev: !production,
      preprocess: sveltePreprocess(),
			css: css => {
				css.write('bundle.css');
			}
		}),
		resolve({
			browser: true,
      extensions: ['.js', '.coffee'],
			dedupe: ['svelte']
		}),
    commonjs({
      extensions: ['.js', '.coffee'],
      include: 'node_modules/**'
    }),
		!production && serve(),
		!production && livereload('public'),
		production && terser()
	],
	watch: {
		clearScreen: false
	}
};
