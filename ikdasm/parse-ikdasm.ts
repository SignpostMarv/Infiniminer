import { createHash } from 'node:crypto';
import {
	glob,
	readFile,
} from 'node:fs/promises';
import { basename } from 'node:path';

const regex = /\.publickey = (\(.+ \)) .+ \.ver (\d+:\d+:\d+:\d+)/s;

for await (const ikdasm_path of glob(`${import.meta.dirname}/*.dll.txt`)) {
	const dll = basename(ikdasm_path, '.txt');
	const ikdasm_output = (await readFile(ikdasm_path)).toString();
	const maybe = regex.exec(ikdasm_output.toString()) as (
		| null
		| (
			& RegExpExecArray
			& [
				string,
				string,
				`${number}:${number}:${number}:${number}`,
			]
		)
	);

	if (!maybe) {
		console.error(`Failed to extract publickey for ${dll}`);

		continue;
	}

	const [, publickey_raw, version] = maybe;

	const public_key_token = createHash('sha1')
		.update(
			Buffer.from(
				publickey_raw.replace(
					/(\s+\/\/.+|\s+)/g,
					'',
				).substring(1, 577),
				'hex',
			)
		)
		.digest()
		.subarray(-8)
		.reverse()
		.toString('hex');

	console.log(`${
		dll
	}\n\tVersion: ${
		version.replaceAll(':', '.')
	}\n\tPublic Key Token ${
		public_key_token
	}`);
}
