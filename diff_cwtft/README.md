# Provisioning `diff_cwtft`

The below steps will only work for macOS and will require some changes for Linux and MS Windows.

## Step 1: Build wavelib

From the project root directory, do:

```bash
cd wavelib
cmake CMakeLists.txt

export MACOSX_DEPLOYMENT_TARGET=10.15
make

git clean -fd
git checkout .
```

`make` builds the library and `git clean` cleans auxiliary build files. To test the built library, from the `wavelib` directory, do:

```bash
./Bin/wavelibLibTests
```

## Step II: Build diff_cwtft

From MATLAB, issue the following command from the `diff_cwtft` folder:

```MATLAB
mex -v -I../wavelib/header -L../wavelib/Bin -lwavelib diff_cwtft.c
```
