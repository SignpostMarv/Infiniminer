# Infiniminer

## Building Infiniminer

> [!IMPORTANT]
> The C# implementation currently only builds correctly on Windows due to
> the MonoGame content pipeline insisting on requiring Wine, and trying to
> get Wine behaving in the DevContainer was a massive headache.

### C#

Refer to the C# implementation [README.md](https://github.com/SignpostMarv/Infiniminer/blob/9641084e47c1ffcc48e5a780f1de0fde8984fd90/README.md)


### Rust

#### Troubleshooting

##### Slow Compile

If rust is being slow to compile, consider adding a named volume for the `/app/rust/target/` directory via your `docker-compose.override.yml`, e.g.

```yml
devcontainer:
    volumes:
        - infiniminer-rust-target:/app/rust/target/
volumes:
    infiniminer-rust-target:
        external: true
```
