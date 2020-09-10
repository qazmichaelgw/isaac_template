workspace(name = "$workspace_name")

# Point following dependency to Isaac SDK downloaded from https://developer.nvidia.com/isaac/downloads
local_repository(
    name = "com_nvidia_isaac",
    path = "$isaac_path",
)

load("@com_nvidia_isaac//third_party:engine.bzl", "isaac_engine_workspace")
load("@com_nvidia_isaac//third_party:packages.bzl", "isaac_packages_workspace")
load("@com_nvidia_isaac//engine/build:isaac.bzl", "isaac_git_repository", "isaac_http_archive")

isaac_engine_workspace()

isaac_packages_workspace()

# Loads before boost to override for aarch64 specific config
isaac_http_archive(
    name = "org_lzma_lzma",
    build_file = "@com_nvidia_isaac//third_party:lzma.BUILD",
    licenses = ["@org_lzma_lzma//:COPYING"],
    sha256 = "9717ae363760dedf573dad241420c5fea86256b65bc21d2cf71b2b12f0544f4b",
    strip_prefix = "xz-5.2.4",
    type = "tar.xz",
    url = "https://developer.nvidia.com/isaac/download/third_party/xz-5-2-4-tar-xz",
)

# Loads boost c++ library (https://www.boost.org/) and
# custom bazel build support (https://github.com/nelhage/rules_boost/)
# explicitly due to bazel bug: https://github.com/bazelbuild/bazel/issues/1550
isaac_http_archive(
    name = "com_github_nelhage_rules_boost",
    licenses = ["@com_github_nelhage_rules_boost//:LICENSE"],
    patches = ["@com_nvidia_isaac//third_party:rules_boost.patch"],
    sha256 = "1479f6a46d37c415b0f803186bacb7a78f76305331c556bba20d13247622752a",
    type = "tar.gz",
    url = "https://developer.nvidia.com/isaac/download/third_party/rules_boost-82ae1790cef07f3fd618592ad227fe2d66fe0b31-tar-gz",
)

load("@com_github_nelhage_rules_boost//:boost/boost.bzl", "boost_deps")

boost_deps()

# Configures toolchain
load("@com_nvidia_isaac//engine/build/toolchain:toolchain.bzl", "toolchain_configure")

toolchain_configure(name = "toolchain")

####################################################################################################

# Local repository specific dependencies

load(":repositories.bzl", "${workspace_name}_workspace")

${workspace_name}_workspace()
