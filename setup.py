import os

from distutils.core import setup, Extension
from Cython.Build import cythonize


PROTOS = ["src/sentence.proto", "src/feature_extractor.proto",
          "src/task_spec.proto"]


def ensure_protobuf():
    if not os.path.exists("./src/cld_3/protos"):
        os.makedirs("./src/cld_3/protos")
    os.system("protoc {} --cpp_out=./src/cld_3/protos/"
              .format(" ".join(PROTOS)))


ext = Extension(
    "cld3",
    sources=[
        "src/cld3.pyx",
        "src/base.cc",
        "src/cld_3/protos/sentence.pb.cc",
        "src/cld_3/protos/feature_extractor.pb.cc",
        "src/cld_3/protos/task_spec.pb.cc",
        "src/embedding_feature_extractor.cc",
        "src/embedding_network.cc",
        "src/feature_extractor.cc",
        "src/feature_types.cc",
        "src/fml_parser.cc",
        "src/language_identifier_features.cc",
        "src/lang_id_nn_params.cc",
        "src/nnet_language_identifier.cc",
        "src/registry.cc",
        "src/sentence_features.cc",
        "src/script_span/fixunicodevalue.cc",
        "src/script_span/generated_entities.cc",
        "src/script_span/generated_ulscript.cc",
        "src/script_span/getonescriptspan.cc",
        "src/script_span/offsetmap.cc",
        "src/script_span/utf8statetable.cc",
        "src/task_context.cc",
        "src/task_context_params.cc",
        "src/utils.cc",
        "src/workspace.cc"],
    include_paths=["./src"],
    libraries=['protobuf'],
    language='c++',
    extra_compile_args=['-std=c++11'])

ensure_protobuf()
setup(
    name='cld3',
    version='0.1',
    author="Google, Johannes Baiter",
    description="CLD3 Python bindings",
    ext_modules=cythonize([ext]))
