#! /bin/bash

# This script _must_ be called from the project
# root directory.

root_dir=$(pwd)
auto_dir="${root_dir}"/src/minijava/_auto
jtb="${root_dir}"/lib/jtb132di.jar
javacc="${root_dir}"/lib/javacc5.jar
jtb_grammar="${root_dir}/grammar/minijava-jtb.jj"
javacc_grammar="${root_dir}"/grammar/minijava.jj

rm -rf "${auto_dir}"
rm -f "${jtb_grammar}"

mkdir -p "${auto_dir}"
cd "${auto_dir}" || {
  echo "cd failed"
  exit 1
}
java -jar "${jtb}" -tk -f -te -o "${jtb_grammar}" -p minijava._auto "${javacc_grammar}"
java -jar "${javacc}" -OUTPUT_DIRECTORY="${auto_dir}"/parser "${jtb_grammar}"

tmp=$(mktemp)
cd "${auto_dir}"/parser || {
  rm "${tmp}"
  echo "cd failed"
  exit 1
}
# TODO use find -exec
for file in $(find -type f -printf "%f\n"); do
  awk 'done != 1 && /^(public|import)/ {
        print "package minijava._auto.parser;\n"
        done = 1
    } 1' "${file}" >"${tmp}"
  cp "${tmp}" "${file}"
done
rm "${tmp}"
