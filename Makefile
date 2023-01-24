ROOT_DIR = ${shell pwd}
SRC_DIR = ${ROOT_DIR}/src
MJ_DIR = ${SRC_DIR}/minijava
SCRIPTS_DIR = ${ROOT_DIR}/scripts
JAR_DIR = ${ROOT_DIR}/lib
GRAMMAR_DIR = ${ROOT_DIR}/grammar
BIN_DIR = ${ROOT_DIR}/bin/
AUTO_DIR = ${MJ_DIR}/_auto

JTB = ${JAR_DIR}/jtb132di.jar
JAVACC = ${JAR_DIR}/javacc5.jar

MINIJAVA_GRAMMAR = ${GRAMMAR_DIR}/minijava.jj
JTB_GRAMMAR = ${GRAMMAR_DIR}/minijava-jtb.jj

INPUT_FILES ?= minijava-examples-new/BinaryTree.java

.PHONY: all
all: jtb javacc compile

.PHONY: compile-execute
compile-execute: compile execute

.PHONY: execute
execute:
	java -cp ${BIN_DIR} minijava.Main ${INPUT_FILES}

.PHONY: compile
.ONESHELL: compile
compile:
	cd ${MJ_DIR}
	javac -cp ${SRC_DIR} -d ${BIN_DIR} Main.java

.PHONY: javacc
javacc: jtb
	java -jar ${JAVACC} -OUTPUT_DIRECTORY=${AUTO_DIR}/parser ${JTB_GRAMMAR}
	${SCRIPTS_DIR}/generate_visitors.sh

.PHONY: jtb
.ONESHELL: jtb
jtb:
	mkdir -p ${AUTO_DIR}
	cd ${AUTO_DIR}
	java -jar ${JTB} -tk -f -te -o ${JTB_GRAMMAR} -p minijava._auto ${MINIJAVA_GRAMMAR}

.PHONY: clean
clean:
	rm -rf ${BIN_DIR} ${AUTO_DIR}
	rm -f ${JTB_GRAMMAR}
	rm -rf offsets