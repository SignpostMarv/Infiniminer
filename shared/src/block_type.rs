use bevy::prelude::*;

#[derive(
	Debug,
	Copy,
	Clone,
	PartialEq,
	Eq,
	Hash,
	Component
)]
pub enum BlockType
{
	None,
	Dirt,
	Ore,
	Gold,
	Diamond,
	Rock,
	Ladder,
	Explosive,
	Jump,
	Shock,
	BankRed,
	BankBlue,
	BeaconRed,
	BeaconBlue,
	Road,
	SolidRed,
	SolidBlue,
	Metal,
	DirtSign,
	Lava,
	TransRed,
	TransBlue,
	MAXIMUM
}
