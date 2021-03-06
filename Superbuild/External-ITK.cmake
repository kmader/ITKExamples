#---------------------------------------------------------------------------
# Get and build itk

if(NOT ITK_TAG)
  # 2018-02-23 master
  set( ITK_TAG "06c6b05e0cf5b912375b2d189d10d7a92b4f4164" )
endif()

set( _vtk_args )
if( VTK_DIR OR ITKExamples_USE_VTK )
  set( _vtk_args "-DVTK_DIR:PATH=${VTK_DIR}"
    -DModule_ITKVtkGlue:BOOL=ON
    -DModule_ITKLevelSetsv4Visualization:BOOL=ON
    )
else()
  set( _vtk_args
    -DModule_ITKVtkGlue:BOOL=OFF
    -DModule_ITKLevelSetsv4Visualization:BOOL=OFF
    )
endif()

set( _opencv_args )
if( OpenCV_DIR OR ITKExamples_USE_OpenCV )
  set( _opencv_args "-DOpenCV_DIR:PATH=${OpenCV_DIR}"
    -DModule_ITKVideoBridgeOpenCV:BOOL=ON
    )
else()
  set( _opencv_args
    -DModule_ITKVideoBridgeOpenCV:BOOL=OFF
    )
endif()

set(_wrap_python_args )
if(ITKExamples_USE_WRAP_PYTHON)
  set(_python_depends)
  if(NOT EXISTS PYTHON_EXECUTABLE)
    set(_python_depends ITKPython)
  endif()
  set(_wrap_python_args
    "-DPYTHON_EXECUTABLE:FILEPATH=${ITKPYTHON_EXECUTABLE}"
    )
endif()

ExternalProject_Add(ITK
  GIT_REPOSITORY "${git_protocol}://github.com/InsightSoftwareConsortium/ITK.git"
  GIT_TAG "${ITK_TAG}"
  SOURCE_DIR ITK
  BINARY_DIR ITK-build
  CMAKE_GENERATOR ${gen}
  CMAKE_ARGS
    ${ep_common_args}
    -DBUILD_SHARED_LIBS:BOOL=OFF
    -DBUILD_EXAMPLES:BOOL=OFF
    -DBUILD_TESTING:BOOL=OFF
    -DITK_BUILD_DEFAULT_MODULES:BOOL=ON
    -DModule_ITKReview:BOOL=ON
    -DITK_LEGACY_SILENT:BOOL=ON
    -DExternalData_OBJECT_STORES:STRING=${ExternalData_OBJECT_STORES}
    "-DITK_USE_SYSTEM_ZLIB:BOOL=ON"
    "-DZLIB_ROOT:PATH=${ZLIB_ROOT}"
    "-DZLIB_INCLUDE_DIR:PATH=${ZLIB_INCLUDE_DIR}"
    "-DZLIB_LIBRARY:FILEPATH=${ZLIB_LIBRARY}"
    ${_vtk_args}
    ${_opencv_args}
    ${_wrap_python_args}
  INSTALL_COMMAND ${CMAKE_COMMAND} -E echo "ITK install skipped"
  DEPENDS ${ITK_DEPENDENCIES} ${_python_depends} zlib
  LOG_BUILD 0
)

set(ITK_DIR ${CMAKE_BINARY_DIR}/ITK-build)
