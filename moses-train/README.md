# Moses Train container

Run it like this

``docker run --name=<container_name> -v <directory_with_corpus_and_models>:/home/moses/models moses-train <corpus_name> <source_lang> <dest_lang>``

For example with corpus ``ru-en`` in local directory ``/data/models/ru-en`` and ru->en translation 

``docker run --name=train-ru-en -v /data/models/ru-en:/home/moses/models moses-train ru-en ru en``

### Release ###

If you need to clean up results of training from learning data, you can call docker run with `--release` key.

It will create two files:

* `release.tar` is an archive with all the files produced by Moses: configuration file, phrase table and language model
* `release.checksum` is a checksum of tarball.



