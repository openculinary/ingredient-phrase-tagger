# RecipeRadar Ingredient Phrase Tagger

This component is a thin wrapper around the [ingredient-phrase-tagger](https://hub.docker.com/r/mtlynch/ingredient-phrase-tagger) docker container created by developer [mtlynch](https://github.com/mtlynch), which in turn is built upon the [ingredient-phrase-tagger](https://github.com/NYTimes/ingredient-phrase-tagger) codebase developed and published by the New York Times Company.

The wrapper exists solely to build a base image containing a ready-trained ingredient phrase tagging model which is accessible via symlink at a fixed filesystem path.

The [ingredient-parser](../ingredient-parser) service image is built on top of the image produced by this repository.

## Install dependencies

Make sure to follow the RecipeRadar [infrastructure](../infrastructure) setup to ensure all cluster dependencies are available in your environment.

## Local Build

To build the image for the local infrastructure environment, execute the following command:

```
sudo sh -x ./build.sh
```
