#!/bin/bash

# Check for correct number of arguments and formatting
# If two arguments and first one is path then declare the two variables and append path slash if missing
# else print error message
# If one argument assume project name and current path

path=""

if [[ $# -eq 2 ]]; then
	if [[ -d "$1" ]]; then
		path="`cd $1 && pwd`/"
		project_name="$2"
	else
		echo 'Your path name is malformed. Type in: NewProject path project_name'
		exit 1
	fi
elif [[ $# -eq 1 ]]; then
	project_name="$1"
	path="`pwd`/"
fi

# Check for correct project_name formatting

if [[ -z "${project_name}" ]]; then
	echo 'Project name is missing. Type in: NewProject path project_name'
	exit 1
fi

# Make project directory and subdirectories and declare variables holding their paths

project_path="${path}${project_name}/"
mkdir "${project_path}"
for dir_name in 'docs' 'source' 'backup' 'archive'
do
	mkdir "${project_path}${dir_name}"
done

#-------------------------------------------------------------------------------
# Compiling script
# usage: compile [-o executable_name] [file_name]...
#-------------------------------------------------------------------------------

script="${project_path}source/compile"

# Write script line by line

cat <<EOF > ${script}
#!/bin/bash

executable_name="a.out"

# Check arguments for executable_name

if [[ \$1 == "-o" ]]; then
	executable_name=\$2
	shift; shift
fi

# Check arguments for file_name(s)

if [[ \$# -eq 0 ]]; then
	echo "You are missing file names. Type in: compile -o executable_name file_name(s)"
	exit 1
fi

# Backup source files

cp \$@ ${project_path}backup/

# Compile using gcc and redirect stderr to "error" text file

gcc \$@ -o "\${executable_name}" 2>${project_path}source/error

# View error text file with more

more ${project_path}source/error

EOF

# Make script executable

chmod a+x "${script}"

# END OF SCRIPT
