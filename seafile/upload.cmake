## Inputs:
#
# NAME_BASE
# EXTENSION
# BIN_DIR
# BUILD_DATE
#
## Values taken from envrionment variables:
#
# SEAFILE_TOKEN
# SEAFILE_SERVER
# SEAFILE_REPOSITORY_ID

if("$ENV{SEAFILE_TOKEN}" STREQUAL "")
  message(FATAL_ERROR "Environment variable SEAFILE_TOKEN is not set! Upload cannot proceed")
endif()

if("$ENV{SEAFILE_SERVER}" STREQUAL "")
  message(FATAL_ERROR "Environment variable SEAFILE_SERVER is not set! Upload cannot proceed")
endif()

if("$ENV{SEAFILE_REPOSITORY_ID}" STREQUAL "")
  message(FATAL_ERROR "Environment variable SEAFILE_REPOSITORY_ID is not set! Upload cannot proceed")
endif()

file(GLOB FILES
  LIST_DIRECTORIES false
  RELATIVE ${BIN_DIR}
  ${NAME_BASE}*.${EXTENSION}
)

if("${FILES}" STREQUAL "")
  message(FATAL_ERROR "No files to deploy with extension ${EXTENSION}")
endif()

foreach(FILE ${FILES})
  SET(NEW_FILE "${BUILD_DATE}-${FILE}")
  file(RENAME "${FILE}" "${NEW_FILE}")

  # Find CURL, used to upload files to Seafile
  find_program(CURL_PATH curl REQUIRED)

  execute_process(
   COMMAND "${CMAKE_COMMAND}" -E echo "Uploading to Seafile: ${NEW_FILE}"
  )

  # Get upload link from Seafile
  execute_process(
    COMMAND "${CURL_PATH}" -H "Authorization: Token $ENV{SEAFILE_TOKEN}" $ENV{SEAFILE_SERVER}/api2/repos/$ENV{SEAFILE_REPOSITORY_ID}/upload-link/

    OUTPUT_VARIABLE UPLOAD_LINK_QUOTED
  )

  # Response from Seafile contains quotes, which CURL refuses to parse. The code
  # below cuts the quotes from the URL string
  string(STRIP ${UPLOAD_LINK_QUOTED} UPLOAD_LINK_QUOTED)
  string(LENGTH ${UPLOAD_LINK_QUOTED} UPLOAD_LINK_LENGTH)
  math(EXPR END_INDEX "${UPLOAD_LINK_LENGTH} - 2")
  string(SUBSTRING ${UPLOAD_LINK_QUOTED} 1 ${END_INDEX} UPLOAD_LINK)

  execute_process(
   COMMAND "${CMAKE_COMMAND}" -E echo LINK IS: ${UPLOAD_LINK}
  )

  # Upload file to Seafile
  execute_process(
    COMMAND "${CURL_PATH}" -H "Authorization: Token $ENV{SEAFILE_TOKEN}" -F file=@${NEW_FILE} -F filename=${NEW_FILE} -F parent_dir=/packages/ -F replace=1 ${UPLOAD_LINK}
  )
endforeach()
