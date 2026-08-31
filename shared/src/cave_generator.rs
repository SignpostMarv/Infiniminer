use noise::Perlin;
use rand::rngs::ThreadRng;
use rand::RngExt;

use crate::block_type::BlockType;
use crate::index_to_xyz;

pub fn generate_cave_system(
	mut rng: ThreadRng,
	size: u8,
	include_lava: bool,
	ore_factor: u8
)
{
	let gradient_strength = rng.random::<f32>();

	let cave_data = generate_constant(size, BlockType::Dirt);
}

pub fn generate_constant(
	size: u8,
	value: BlockType,
)
{
	let length = (size as u32).pow(3);

	vec![value; length as usize];
}

pub fn generate_noise(
	size: u8,
	mut rng: ThreadRng,
)
{
	let length = (size as u32).pow(3) as usize;
	let seed = rng.random::<u32>();
	let perlin = Perlin::new(seed);
	let noise: vec![f32] = (0..length).map(|i| {
		let (x, y, z) = index_to_xyz(size, index);

		perlin.get([x, y, z]);
	});

	noise;
}
