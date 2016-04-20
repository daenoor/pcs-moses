#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os, errno
import shutil
import subprocess
from argparse import ArgumentParser

MOSES_HOME = os.environ.get('MOSES_HOME')
MOSES_DIR = os.environ.get('MOSES_DIR')
MODELS_DIR = os.environ.get('MOSES_MODEL_DIR')
#IRSTLM_HOME = os.path.join(MOSES_HOME, 'irstlm/bin')

MGIZA_CPUS = os.environ.get('MGIZA_CPUS', 2)

corpus_base = None

def get_tool(name):
    return os.path.join(MOSES_HOME, 'toolkit', name+'.sh')

def run_command(cmd):
    cmd.insert(0, 'sh')
    subprocess.check_call(cmd)

def corpus_file(lang, suffix=''):
    if suffix:
        suffix += '.'
    return corpus_base + suffix + lang

parser = ArgumentParser()
parser.add_argument("corpus", help="Corpus name")
parser.add_argument("source", help="Source language")
parser.add_argument("target", help="Target language")
parser.add_argument("-r", "--release", action="store_true", help="If given, container will release the model prepared earlier.")

args = parser.parse_args()



# Check corpus file availability
corpus_base = args.corpus + '.'
src_corpus = corpus_base + args.source
tgt_corpus = corpus_base + args.target

# Check if release is called
if args.release:
    run_command([get_tool('release'), '-c', args.corpus, '-s', args.source, '-t', args.target])
    exit(0)

if not os.path.isfile(src_corpus):
    print "Corpus source part is not available (file " + src_corpus + " doesn't exist)"
    exit(1)

if not os.path.isfile(tgt_corpus):
    print "Corpus target part is not available (file " + tgt_corpus + " doesn't exist)"
    exit(1)


# Prepare corpus
run_command([get_tool('prepare_corpus'), '-c', args.corpus, '-s', args.source, '-t', args.target])

# Build LM from corpus
run_command([get_tool('train_lm'), '-c', args.corpus, '-t', args.target])

# Build translation model from corpus/LM
run_command([get_tool('train_engine'), '-c', args.corpus, '-s', args.source, '-t', args.target])
