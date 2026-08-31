/**
 * This is currently a relatively simple function so we can do memory optimisations later
 */
pub fn position_to_index(
	size: u8,
	x: u8,
	y: u8,
	z: u8
) -> usize {
	(
		(x as usize)
		+ ((y as usize) * (size as usize))
		+ ((z as usize) * (size as usize).pow(2))
	)
}

pub fn index_to_xyz(
	size: u8,
	index: usize
) -> (u8, u8, u8) {
	let maximum = (size as usize).pow(3);

	assert!(
		index < maximum,
		"Expecting a maximum index of {}, was given {}",
		maximum,
		index,
	);

	let size_as_usize = (size as usize);

	let x = (index % size_as_usize) as u8;
	let y = ((index / size_as_usize) % size_as_usize) as u8;
	let z = (index / size_as_usize.pow(2)) as u8;

	return (x, y, z);
}
