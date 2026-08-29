sudo chown -R vscode:vscode \
	/app/csharp/ \
	/archive/infiniminer/ \
	/home/vscode/
git submodule update --init --recursive

cargo install cargo-xwin --locked
echo "export RUST_LIB_DIR=\$(rustc --print target-libdir)" >> ~/.bashrc
echo 'export LD_LIBRARY_PATH="/app/target/debug/deps:$RUST_LIB_DIR:$LD_LIBRARY_PATH"' >> ~/.bashrc
