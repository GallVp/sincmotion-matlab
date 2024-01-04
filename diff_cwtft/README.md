# Provisioning `diff_cwtft`

The below steps will only work on macOS and will require some changes before on Linux and MS Windows.

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

That builds the library and cleans auxiliary build files. To test, from the `wavelib` directory, do:

```bash
./Bin/wavelibLibTests
```

## Step II: Build diff_cwtft

From MATLAB, issue the following command from the `diff_cwtft` folder:

```MATLAB
mex -v -I../wavelib/header -L../wavelib/Bin -lwavelib diff_cwtft.c
```
