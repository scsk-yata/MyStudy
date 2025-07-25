/* DO NOT EDIT! GENERATED AUTOMATICALLY! */
/* A more-standard <time.h>.

   Copyright (C) 2007-2024 Free Software Foundation, Inc.

   This file is free software: you can redistribute it and/or modify
   it under the terms of the GNU Lesser General Public License as
   published by the Free Software Foundation; either version 2.1 of the
   License, or (at your option) any later version.

   This file is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

#if __GNUC__ >= 3
#pragma GCC system_header
#endif


/* This file uses #include_next of a system file that defines time_t.
   For the 'year2038' module to work right, <config.h> needs to have been
   included before.  */
#if !_GL_CONFIG_H_INCLUDED
 #error "Please include config.h first."
#endif

/* Don't get in the way of glibc when it includes time.h merely to
   declare a few standard symbols, rather than to declare all the
   symbols.  (However, skip this for MinGW as it treats __need_time_t
   incompatibly.)  Also, Solaris 8 <time.h> eventually includes itself
   recursively; if that is happening, just include the system <time.h>
   without adding our own declarations.  */
#if (((defined __need_time_t || defined __need_clock_t \
       || defined __need_timespec)                     \
      && !defined __MINGW32__)                         \
     || defined _GL_TIME_H)

# include_next <time.h>

#else

# define _GL_TIME_H

/* mingw's <time.h> provides the functions asctime_r, ctime_r, gmtime_r,
   localtime_r only if <unistd.h> or <pthread.h> has been included before.  */
# if defined __MINGW32__
#  include <unistd.h>
# endif

# include_next <time.h>

/* This file uses _GL_ATTRIBUTE_DEPRECATED, GNULIB_POSIXCHECK,
   HAVE_RAW_DECL_*.  */
# if !_GL_CONFIG_H_INCLUDED
#  error "Please include config.h first."
# endif

/* NetBSD 5.0 mis-defines NULL.  */
# include <stddef.h>

/* The definitions of _GL_FUNCDECL_RPL etc. are copied here.  */
/* C++ compatible function declaration macros.
   Copyright (C) 2010-2024 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify it
   under the terms of the GNU Lesser General Public License as published
   by the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

#ifndef _GL_CXXDEFS_H
#define _GL_CXXDEFS_H

/* Begin/end the GNULIB_NAMESPACE namespace.  */
#if defined __cplusplus && defined GNULIB_NAMESPACE
# define _GL_BEGIN_NAMESPACE namespace GNULIB_NAMESPACE {
# define _GL_END_NAMESPACE }
#else
# define _GL_BEGIN_NAMESPACE
# define _GL_END_NAMESPACE
#endif

/* The three most frequent use cases of these macros are:

   * For providing a substitute for a function that is missing on some
     platforms, but is declared and works fine on the platforms on which
     it exists:

       #if @GNULIB_FOO@
       # if !@HAVE_FOO@
       _GL_FUNCDECL_SYS (foo, ...);
       # endif
       _GL_CXXALIAS_SYS (foo, ...);
       _GL_CXXALIASWARN (foo);
       #elif defined GNULIB_POSIXCHECK
       ...
       #endif

   * For providing a replacement for a function that exists on all platforms,
     but is broken/insufficient and needs to be replaced on some platforms:

       #if @GNULIB_FOO@
       # if @REPLACE_FOO@
       #  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
       #   undef foo
       #   define foo rpl_foo
       #  endif
       _GL_FUNCDECL_RPL (foo, ...);
       _GL_CXXALIAS_RPL (foo, ...);
       # else
       _GL_CXXALIAS_SYS (foo, ...);
       # endif
       _GL_CXXALIASWARN (foo);
       #elif defined GNULIB_POSIXCHECK
       ...
       #endif

   * For providing a replacement for a function that exists on some platforms
     but is broken/insufficient and needs to be replaced on some of them and
     is additionally either missing or undeclared on some other platforms:

       #if @GNULIB_FOO@
       # if @REPLACE_FOO@
       #  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
       #   undef foo
       #   define foo rpl_foo
       #  endif
       _GL_FUNCDECL_RPL (foo, ...);
       _GL_CXXALIAS_RPL (foo, ...);
       # else
       #  if !@HAVE_FOO@   or   if !@HAVE_DECL_FOO@
       _GL_FUNCDECL_SYS (foo, ...);
       #  endif
       _GL_CXXALIAS_SYS (foo, ...);
       # endif
       _GL_CXXALIASWARN (foo);
       #elif defined GNULIB_POSIXCHECK
       ...
       #endif
*/

/* _GL_EXTERN_C declaration;
   performs the declaration with C linkage.  */
#if defined __cplusplus
# define _GL_EXTERN_C extern "C"
#else
# define _GL_EXTERN_C extern
#endif

/* _GL_FUNCDECL_RPL (func, rettype, parameters_and_attributes);
   declares a replacement function, named rpl_func, with the given prototype,
   consisting of return type, parameters, and attributes.
   Example:
     _GL_FUNCDECL_RPL (open, int, (const char *filename, int flags, ...)
                                  _GL_ARG_NONNULL ((1)));

   Note: Attributes, such as _GL_ATTRIBUTE_DEPRECATED, are supported in front
   of a _GL_FUNCDECL_RPL invocation only in C mode, not in C++ mode.  (That's
   because
     [[...]] extern "C" <declaration>;
   is invalid syntax in C++.)
 */
#define _GL_FUNCDECL_RPL(func,rettype,parameters_and_attributes) \
  _GL_FUNCDECL_RPL_1 (rpl_##func, rettype, parameters_and_attributes)
#define _GL_FUNCDECL_RPL_1(rpl_func,rettype,parameters_and_attributes) \
  _GL_EXTERN_C rettype rpl_func parameters_and_attributes

/* _GL_FUNCDECL_SYS (func, rettype, parameters_and_attributes);
   declares the system function, named func, with the given prototype,
   consisting of return type, parameters, and attributes.
   Example:
     _GL_FUNCDECL_SYS (open, int, (const char *filename, int flags, ...)
                                  _GL_ARG_NONNULL ((1)));
 */
#define _GL_FUNCDECL_SYS(func,rettype,parameters_and_attributes) \
  _GL_EXTERN_C rettype func parameters_and_attributes

/* _GL_CXXALIAS_RPL (func, rettype, parameters);
   declares a C++ alias called GNULIB_NAMESPACE::func
   that redirects to rpl_func, if GNULIB_NAMESPACE is defined.
   Example:
     _GL_CXXALIAS_RPL (open, int, (const char *filename, int flags, ...));

   Wrapping rpl_func in an object with an inline conversion operator
   avoids a reference to rpl_func unless GNULIB_NAMESPACE::func is
   actually used in the program.  */
#define _GL_CXXALIAS_RPL(func,rettype,parameters) \
  _GL_CXXALIAS_RPL_1 (func, rpl_##func, rettype, parameters)
#if defined __cplusplus && defined GNULIB_NAMESPACE
# define _GL_CXXALIAS_RPL_1(func,rpl_func,rettype,parameters) \
    namespace GNULIB_NAMESPACE                                \
    {                                                         \
      static const struct _gl_ ## func ## _wrapper            \
      {                                                       \
        typedef rettype (*type) parameters;                   \
                                                              \
        inline operator type () const                         \
        {                                                     \
          return ::rpl_func;                                  \
        }                                                     \
      } func = {};                                            \
    }                                                         \
    _GL_EXTERN_C int _gl_cxxalias_dummy
#else
# define _GL_CXXALIAS_RPL_1(func,rpl_func,rettype,parameters) \
    _GL_EXTERN_C int _gl_cxxalias_dummy
#endif

/* _GL_CXXALIAS_MDA (func, rettype, parameters);
   is to be used when func is a Microsoft deprecated alias, on native Windows.
   It declares a C++ alias called GNULIB_NAMESPACE::func
   that redirects to _func, if GNULIB_NAMESPACE is defined.
   Example:
     _GL_CXXALIAS_MDA (open, int, (const char *filename, int flags, ...));
 */
#define _GL_CXXALIAS_MDA(func,rettype,parameters) \
  _GL_CXXALIAS_RPL_1 (func, _##func, rettype, parameters)

/* _GL_CXXALIAS_RPL_CAST_1 (func, rpl_func, rettype, parameters);
   is like  _GL_CXXALIAS_RPL_1 (func, rpl_func, rettype, parameters);
   except that the C function rpl_func may have a slightly different
   declaration.  A cast is used to silence the "invalid conversion" error
   that would otherwise occur.  */
#if defined __cplusplus && defined GNULIB_NAMESPACE
# define _GL_CXXALIAS_RPL_CAST_1(func,rpl_func,rettype,parameters) \
    namespace GNULIB_NAMESPACE                                     \
    {                                                              \
      static const struct _gl_ ## func ## _wrapper                 \
      {                                                            \
        typedef rettype (*type) parameters;                        \
                                                                   \
        inline operator type () const                              \
        {                                                          \
          return reinterpret_cast<type>(::rpl_func);               \
        }                                                          \
      } func = {};                                                 \
    }                                                              \
    _GL_EXTERN_C int _gl_cxxalias_dummy
#else
# define _GL_CXXALIAS_RPL_CAST_1(func,rpl_func,rettype,parameters) \
    _GL_EXTERN_C int _gl_cxxalias_dummy
#endif

/* _GL_CXXALIAS_MDA_CAST (func, rettype, parameters);
   is like  _GL_CXXALIAS_MDA (func, rettype, parameters);
   except that the C function func may have a slightly different declaration.
   A cast is used to silence the "invalid conversion" error that would
   otherwise occur.  */
#define _GL_CXXALIAS_MDA_CAST(func,rettype,parameters) \
  _GL_CXXALIAS_RPL_CAST_1 (func, _##func, rettype, parameters)

/* _GL_CXXALIAS_SYS (func, rettype, parameters);
   declares a C++ alias called GNULIB_NAMESPACE::func
   that redirects to the system provided function func, if GNULIB_NAMESPACE
   is defined.
   Example:
     _GL_CXXALIAS_SYS (open, int, (const char *filename, int flags, ...));

   Wrapping func in an object with an inline conversion operator
   avoids a reference to func unless GNULIB_NAMESPACE::func is
   actually used in the program.  */
#if defined __cplusplus && defined GNULIB_NAMESPACE
# define _GL_CXXALIAS_SYS(func,rettype,parameters)            \
    namespace GNULIB_NAMESPACE                                \
    {                                                         \
      static const struct _gl_ ## func ## _wrapper            \
      {                                                       \
        typedef rettype (*type) parameters;                   \
                                                              \
        inline operator type () const                         \
        {                                                     \
          return ::func;                                      \
        }                                                     \
      } func = {};                                            \
    }                                                         \
    _GL_EXTERN_C int _gl_cxxalias_dummy
#else
# define _GL_CXXALIAS_SYS(func,rettype,parameters) \
    _GL_EXTERN_C int _gl_cxxalias_dummy
#endif

/* _GL_CXXALIAS_SYS_CAST (func, rettype, parameters);
   is like  _GL_CXXALIAS_SYS (func, rettype, parameters);
   except that the C function func may have a slightly different declaration.
   A cast is used to silence the "invalid conversion" error that would
   otherwise occur.  */
#if defined __cplusplus && defined GNULIB_NAMESPACE
# define _GL_CXXALIAS_SYS_CAST(func,rettype,parameters) \
    namespace GNULIB_NAMESPACE                          \
    {                                                   \
      static const struct _gl_ ## func ## _wrapper      \
      {                                                 \
        typedef rettype (*type) parameters;             \
                                                        \
        inline operator type () const                   \
        {                                               \
          return reinterpret_cast<type>(::func);        \
        }                                               \
      } func = {};                                      \
    }                                                   \
    _GL_EXTERN_C int _gl_cxxalias_dummy
#else
# define _GL_CXXALIAS_SYS_CAST(func,rettype,parameters) \
    _GL_EXTERN_C int _gl_cxxalias_dummy
#endif

/* _GL_CXXALIAS_SYS_CAST2 (func, rettype, parameters, rettype2, parameters2);
   is like  _GL_CXXALIAS_SYS (func, rettype, parameters);
   except that the C function is picked among a set of overloaded functions,
   namely the one with rettype2 and parameters2.  Two consecutive casts
   are used to silence the "cannot find a match" and "invalid conversion"
   errors that would otherwise occur.  */
#if defined __cplusplus && defined GNULIB_NAMESPACE
  /* The outer cast must be a reinterpret_cast.
     The inner cast: When the function is defined as a set of overloaded
     functions, it works as a static_cast<>, choosing the designated variant.
     When the function is defined as a single variant, it works as a
     reinterpret_cast<>. The parenthesized cast syntax works both ways.  */
# define _GL_CXXALIAS_SYS_CAST2(func,rettype,parameters,rettype2,parameters2) \
    namespace GNULIB_NAMESPACE                                                \
    {                                                                         \
      static const struct _gl_ ## func ## _wrapper                            \
      {                                                                       \
        typedef rettype (*type) parameters;                                   \
                                                                              \
        inline operator type () const                                         \
        {                                                                     \
          return reinterpret_cast<type>((rettype2 (*) parameters2)(::func));  \
        }                                                                     \
      } func = {};                                                            \
    }                                                                         \
    _GL_EXTERN_C int _gl_cxxalias_dummy
#else
# define _GL_CXXALIAS_SYS_CAST2(func,rettype,parameters,rettype2,parameters2) \
    _GL_EXTERN_C int _gl_cxxalias_dummy
#endif

/* _GL_CXXALIASWARN (func);
   causes a warning to be emitted when ::func is used but not when
   GNULIB_NAMESPACE::func is used.  func must be defined without overloaded
   variants.  */
#if defined __cplusplus && defined GNULIB_NAMESPACE
# define _GL_CXXALIASWARN(func) \
   _GL_CXXALIASWARN_1 (func, GNULIB_NAMESPACE)
# define _GL_CXXALIASWARN_1(func,namespace) \
   _GL_CXXALIASWARN_2 (func, namespace)
/* To work around GCC bug <https://gcc.gnu.org/bugzilla/show_bug.cgi?id=43881>,
   we enable the warning only when not optimizing.  */
# if !(defined __GNUC__ && !defined __clang__ && __OPTIMIZE__)
#  define _GL_CXXALIASWARN_2(func,namespace) \
    _GL_WARN_ON_USE (func, \
                     "The symbol ::" #func " refers to the system function. " \
                     "Use " #namespace "::" #func " instead.")
# elif __GNUC__ >= 3 && GNULIB_STRICT_CHECKING
#  define _GL_CXXALIASWARN_2(func,namespace) \
     extern __typeof__ (func) func
# else
#  define _GL_CXXALIASWARN_2(func,namespace) \
     _GL_EXTERN_C int _gl_cxxalias_dummy
# endif
#else
# define _GL_CXXALIASWARN(func) \
    _GL_EXTERN_C int _gl_cxxalias_dummy
#endif

/* _GL_CXXALIASWARN1 (func, rettype, parameters_and_attributes);
   causes a warning to be emitted when the given overloaded variant of ::func
   is used but not when GNULIB_NAMESPACE::func is used.  */
#if defined __cplusplus && defined GNULIB_NAMESPACE
# define _GL_CXXALIASWARN1(func,rettype,parameters_and_attributes) \
   _GL_CXXALIASWARN1_1 (func, rettype, parameters_and_attributes, \
                        GNULIB_NAMESPACE)
# define _GL_CXXALIASWARN1_1(func,rettype,parameters_and_attributes,namespace) \
   _GL_CXXALIASWARN1_2 (func, rettype, parameters_and_attributes, namespace)
/* To work around GCC bug <https://gcc.gnu.org/bugzilla/show_bug.cgi?id=43881>,
   we enable the warning only when not optimizing.  */
# if !(defined __GNUC__ && !defined __clang__ && __OPTIMIZE__)
#  define _GL_CXXALIASWARN1_2(func,rettype,parameters_and_attributes,namespace) \
    _GL_WARN_ON_USE_CXX (func, rettype, rettype, parameters_and_attributes, \
                         "The symbol ::" #func " refers to the system function. " \
                         "Use " #namespace "::" #func " instead.")
# else
#  define _GL_CXXALIASWARN1_2(func,rettype,parameters_and_attributes,namespace) \
     _GL_EXTERN_C int _gl_cxxalias_dummy
# endif
#else
# define _GL_CXXALIASWARN1(func,rettype,parameters_and_attributes) \
    _GL_EXTERN_C int _gl_cxxalias_dummy
#endif

#endif /* _GL_CXXDEFS_H */

/* The definition of _GL_ARG_NONNULL is copied here.  */
/* A C macro for declaring that specific arguments must not be NULL.
   Copyright (C) 2009-2024 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify it
   under the terms of the GNU Lesser General Public License as published
   by the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* _GL_ARG_NONNULL((n,...,m)) tells the compiler and static analyzer tools
   that the values passed as arguments n, ..., m must be non-NULL pointers.
   n = 1 stands for the first argument, n = 2 for the second argument etc.  */
#ifndef _GL_ARG_NONNULL
# if __GNUC__ > 3 || (__GNUC__ == 3 && __GNUC_MINOR__ >= 3) || defined __clang__
#  define _GL_ARG_NONNULL(params) __attribute__ ((__nonnull__ params))
# else
#  define _GL_ARG_NONNULL(params)
# endif
#endif

/* The definition of _GL_WARN_ON_USE is copied here.  */
/* A C macro for emitting warnings if a function is used.
   Copyright (C) 2010-2024 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify it
   under the terms of the GNU Lesser General Public License as published
   by the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* _GL_WARN_ON_USE (function, "literal string") issues a declaration
   for FUNCTION which will then trigger a compiler warning containing
   the text of "literal string" anywhere that function is called, if
   supported by the compiler.  If the compiler does not support this
   feature, the macro expands to an unused extern declaration.

   _GL_WARN_ON_USE_ATTRIBUTE ("literal string") expands to the
   attribute used in _GL_WARN_ON_USE.  If the compiler does not support
   this feature, it expands to empty.

   These macros are useful for marking a function as a potential
   portability trap, with the intent that "literal string" include
   instructions on the replacement function that should be used
   instead.
   _GL_WARN_ON_USE is for functions with 'extern' linkage.
   _GL_WARN_ON_USE_ATTRIBUTE is for functions with 'static' or 'inline'
   linkage.

   _GL_WARN_ON_USE should not be used more than once for a given function
   in a given compilation unit (because this may generate a warning even
   if the function is never called).

   However, one of the reasons that a function is a portability trap is
   if it has the wrong signature.  Declaring FUNCTION with a different
   signature in C is a compilation error, so this macro must use the
   same type as any existing declaration so that programs that avoid
   the problematic FUNCTION do not fail to compile merely because they
   included a header that poisoned the function.  But this implies that
   _GL_WARN_ON_USE is only safe to use if FUNCTION is known to already
   have a declaration.  Use of this macro implies that there must not
   be any other macro hiding the declaration of FUNCTION; but
   undefining FUNCTION first is part of the poisoning process anyway
   (although for symbols that are provided only via a macro, the result
   is a compilation error rather than a warning containing
   "literal string").  Also note that in C++, it is only safe to use if
   FUNCTION has no overloads.

   For an example, it is possible to poison 'getline' by:
   - adding a call to gl_WARN_ON_USE_PREPARE([[#include <stdio.h>]],
     [getline]) in configure.ac, which potentially defines
     HAVE_RAW_DECL_GETLINE
   - adding this code to a header that wraps the system <stdio.h>:
     #undef getline
     #if HAVE_RAW_DECL_GETLINE
     _GL_WARN_ON_USE (getline, "getline is required by POSIX 2008, but"
       "not universally present; use the gnulib module getline");
     #endif

   It is not possible to directly poison global variables.  But it is
   possible to write a wrapper accessor function, and poison that
   (less common usage, like &environ, will cause a compilation error
   rather than issue the nice warning, but the end result of informing
   the developer about their portability problem is still achieved):
     #if HAVE_RAW_DECL_ENVIRON
     static char ***
     rpl_environ (void) { return &environ; }
     _GL_WARN_ON_USE (rpl_environ, "environ is not always properly declared");
     # undef environ
     # define environ (*rpl_environ ())
     #endif
   or better (avoiding contradictory use of 'static' and 'extern'):
     #if HAVE_RAW_DECL_ENVIRON
     static char ***
     _GL_WARN_ON_USE_ATTRIBUTE ("environ is not always properly declared")
     rpl_environ (void) { return &environ; }
     # undef environ
     # define environ (*rpl_environ ())
     #endif
   */
#ifndef _GL_WARN_ON_USE

# if 4 < __GNUC__ || (__GNUC__ == 4 && 3 <= __GNUC_MINOR__)
/* A compiler attribute is available in gcc versions 4.3.0 and later.  */
#  define _GL_WARN_ON_USE(function, message) \
_GL_WARN_EXTERN_C __typeof__ (function) function __attribute__ ((__warning__ (message)))
#  define _GL_WARN_ON_USE_ATTRIBUTE(message) \
  __attribute__ ((__warning__ (message)))
# elif __clang_major__ >= 4
/* Another compiler attribute is available in clang.  */
#  define _GL_WARN_ON_USE(function, message) \
_GL_WARN_EXTERN_C __typeof__ (function) function \
  __attribute__ ((__diagnose_if__ (1, message, "warning")))
#  define _GL_WARN_ON_USE_ATTRIBUTE(message) \
  __attribute__ ((__diagnose_if__ (1, message, "warning")))
# elif __GNUC__ >= 3 && GNULIB_STRICT_CHECKING
/* Verify the existence of the function.  */
#  define _GL_WARN_ON_USE(function, message) \
_GL_WARN_EXTERN_C __typeof__ (function) function
#  define _GL_WARN_ON_USE_ATTRIBUTE(message)
# else /* Unsupported.  */
#  define _GL_WARN_ON_USE(function, message) \
_GL_WARN_EXTERN_C int _gl_warn_on_use
#  define _GL_WARN_ON_USE_ATTRIBUTE(message)
# endif
#endif

/* _GL_WARN_ON_USE_CXX (function, rettype_gcc, rettype_clang, parameters_and_attributes, "message")
   is like _GL_WARN_ON_USE (function, "message"), except that in C++ mode the
   function is declared with the given prototype, consisting of return type,
   parameters, and attributes.
   This variant is useful for overloaded functions in C++. _GL_WARN_ON_USE does
   not work in this case.  */
#ifndef _GL_WARN_ON_USE_CXX
# if !defined __cplusplus
#  define _GL_WARN_ON_USE_CXX(function,rettype_gcc,rettype_clang,parameters_and_attributes,msg) \
     _GL_WARN_ON_USE (function, msg)
# else
#  if 4 < __GNUC__ || (__GNUC__ == 4 && 3 <= __GNUC_MINOR__)
/* A compiler attribute is available in gcc versions 4.3.0 and later.  */
#   define _GL_WARN_ON_USE_CXX(function,rettype_gcc,rettype_clang,parameters_and_attributes,msg) \
extern rettype_gcc function parameters_and_attributes \
  __attribute__ ((__warning__ (msg)))
#  elif __clang_major__ >= 4
/* Another compiler attribute is available in clang.  */
#   define _GL_WARN_ON_USE_CXX(function,rettype_gcc,rettype_clang,parameters_and_attributes,msg) \
extern rettype_clang function parameters_and_attributes \
  __attribute__ ((__diagnose_if__ (1, msg, "warning")))
#  elif __GNUC__ >= 3 && GNULIB_STRICT_CHECKING
/* Verify the existence of the function.  */
#   define _GL_WARN_ON_USE_CXX(function,rettype_gcc,rettype_clang,parameters_and_attributes,msg) \
extern rettype_gcc function parameters_and_attributes
#  else /* Unsupported.  */
#   define _GL_WARN_ON_USE_CXX(function,rettype_gcc,rettype_clang,parameters_and_attributes,msg) \
_GL_WARN_EXTERN_C int _gl_warn_on_use
#  endif
# endif
#endif

/* _GL_WARN_EXTERN_C declaration;
   performs the declaration with C linkage.  */
#ifndef _GL_WARN_EXTERN_C
# if defined __cplusplus
#  define _GL_WARN_EXTERN_C extern "C"
# else
#  define _GL_WARN_EXTERN_C extern
# endif
#endif

/* Some systems don't define struct timespec (e.g., AIX 4.1).
   Or they define it with the wrong member names or define it in <sys/time.h>
   (e.g., FreeBSD circa 1997).  Stock Mingw prior to 3.0 does not define it,
   but the pthreads-win32 library defines it in <pthread.h>.  */
# if ! 1
#  if 0
#   include <sys/time.h>
#  elif 0
#   include <pthread.h>
#  elif 0
#   include <unistd.h>
#  else

#   ifdef __cplusplus
extern "C" {
#   endif

#   if !GNULIB_defined_struct_timespec
#    undef timespec
#    define timespec rpl_timespec
struct timespec
{
  time_t tv_sec;
  long int tv_nsec;
};
#    define GNULIB_defined_struct_timespec 1
#   endif

#   ifdef __cplusplus
}
#   endif

#  endif
# endif

# if !GNULIB_defined_struct_time_t_must_be_integral
/* https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/sys_types.h.html
   requires time_t to be an integer type, even though C99 permits floating
   point.  We don't know of any implementation that uses floating
   point, and it is much easier to write code that doesn't have to
   worry about that corner case, so we force the issue.  */
struct __time_t_must_be_integral {
  unsigned int __floating_time_t_unsupported : (time_t) 1;
};
#  define GNULIB_defined_struct_time_t_must_be_integral 1
# endif

/* Define TIME_UTC, a positive integer constant used for timespec_get().  */
# if ! 1
#  if !GNULIB_defined_TIME_UTC
#   define TIME_UTC 1
#   define GNULIB_defined_TIME_UTC 1
#  endif
# endif

/* Set *TS to the current time, and return BASE.
   Upon failure, return 0.  */
# if 0
#  if 0
#   if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#    undef timespec_get
#    define timespec_get rpl_timespec_get
#   endif
_GL_FUNCDECL_RPL (timespec_get, int, (struct timespec *ts, int base)
                                     _GL_ARG_NONNULL ((1)));
_GL_CXXALIAS_RPL (timespec_get, int, (struct timespec *ts, int base));
#  else
#   if !1
_GL_FUNCDECL_SYS (timespec_get, int, (struct timespec *ts, int base)
                                     _GL_ARG_NONNULL ((1)));
#   endif
_GL_CXXALIAS_SYS (timespec_get, int, (struct timespec *ts, int base));
#  endif
#  if __GLIBC__ >= 2
_GL_CXXALIASWARN (timespec_get);
#  endif
# elif defined GNULIB_POSIXCHECK
#  undef timespec_get
#  if HAVE_RAW_DECL_TIMESPEC_GET
_GL_WARN_ON_USE (timespec_get, "timespec_get is unportable - "
                 "use gnulib module timespec_get for portability");
#  endif
# endif

/* Set *TS to the current time resolution, and return BASE.
   Upon failure, return 0.  */
# if 0
#  if 0
#   if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#    undef timespec_getres
#    define timespec_getres rpl_timespec_getres
#   endif
_GL_FUNCDECL_RPL (timespec_getres, int, (struct timespec *ts, int base)
                                        _GL_ARG_NONNULL ((1)));
_GL_CXXALIAS_RPL (timespec_getres, int, (struct timespec *ts, int base));
#  else
#   if !1
_GL_FUNCDECL_SYS (timespec_getres, int, (struct timespec *ts, int base)
                                        _GL_ARG_NONNULL ((1)));
#   endif
_GL_CXXALIAS_SYS (timespec_getres, int, (struct timespec *ts, int base));
#  endif
_GL_CXXALIASWARN (timespec_getres);
# elif defined GNULIB_POSIXCHECK
#  undef timespec_getres
#  if HAVE_RAW_DECL_TIMESPEC_GETRES
_GL_WARN_ON_USE (timespec_getres, "timespec_getres is unportable - "
                 "use gnulib module timespec_getres for portability");
#  endif
# endif

/* Return the number of seconds that have elapsed since the Epoch.  */
# if IN_GETTEXT_TOOLS_GNULIB_TESTS
#  if 1
#   if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#    define time rpl_time
#   endif
_GL_FUNCDECL_RPL (time, time_t, (time_t *__tp));
_GL_CXXALIAS_RPL (time, time_t, (time_t *__tp));
#  else
_GL_CXXALIAS_SYS (time, time_t, (time_t *__tp));
#  endif
#  if __GLIBC__ >= 2
_GL_CXXALIASWARN (time);
#  endif
# elif defined GNULIB_POSIXCHECK
#  undef time
#  if HAVE_RAW_DECL_TIME
_GL_WARN_ON_USE (time, "time has consistency problems - "
                 "use gnulib module time for portability");
#  endif
# endif

/* Sleep for at least RQTP seconds unless interrupted,  If interrupted,
   return -1 and store the remaining time into RMTP.  See
   <https://pubs.opengroup.org/onlinepubs/9699919799/functions/nanosleep.html>.  */
# if IN_GETTEXT_TOOLS_GNULIB_TESTS
#  if 1
#   if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#    define nanosleep rpl_nanosleep
#   endif
_GL_FUNCDECL_RPL (nanosleep, int,
                  (struct timespec const *__rqtp, struct timespec *__rmtp)
                  _GL_ARG_NONNULL ((1)));
_GL_CXXALIAS_RPL (nanosleep, int,
                  (struct timespec const *__rqtp, struct timespec *__rmtp));
#  else
#   if ! 1
_GL_FUNCDECL_SYS (nanosleep, int,
                  (struct timespec const *__rqtp, struct timespec *__rmtp)
                  _GL_ARG_NONNULL ((1)));
#   endif
_GL_CXXALIAS_SYS (nanosleep, int,
                  (struct timespec const *__rqtp, struct timespec *__rmtp));
#  endif
_GL_CXXALIASWARN (nanosleep);
# elif defined GNULIB_POSIXCHECK
#  undef nanosleep
#  if HAVE_RAW_DECL_NANOSLEEP
_GL_WARN_ON_USE (nanosleep, "nanosleep is unportable - "
                 "use gnulib module nanosleep for portability");
#  endif
# endif

/* Initialize time conversion information.  */
# if 0
#  if 0
#   if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#    undef tzset
#    define tzset rpl_tzset
#   endif
_GL_FUNCDECL_RPL (tzset, void, (void));
_GL_CXXALIAS_RPL (tzset, void, (void));
#  elif defined _WIN32 && !defined __CYGWIN__
#   if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#    undef tzset
#    define tzset _tzset
#   endif
_GL_CXXALIAS_MDA (tzset, void, (void));
#  else
_GL_CXXALIAS_SYS (tzset, void, (void));
#  endif
_GL_CXXALIASWARN (tzset);
# elif 1
/* On native Windows, map 'tzset' to '_tzset', so that -loldnames is not
   required.  In C++ with GNULIB_NAMESPACE, avoid differences between
   platforms by defining GNULIB_NAMESPACE::tzset always.  */
#  if defined _WIN32 && !defined __CYGWIN__
#   if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#    undef tzset
#    define tzset _tzset
#   endif
_GL_CXXALIAS_MDA (tzset, void, (void));
#  else
_GL_CXXALIAS_SYS (tzset, void, (void));
#  endif
_GL_CXXALIASWARN (tzset);
# elif defined GNULIB_POSIXCHECK
#  undef tzset
#  if HAVE_RAW_DECL_TZSET
_GL_WARN_ON_USE (tzset, "tzset has portability problems - "
                 "use gnulib module tzset for portability");
#  endif
# endif

/* Return the 'time_t' representation of TP and normalize TP.  */
# if 0
#  if 0
#   if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#    define mktime rpl_mktime
#   endif
_GL_FUNCDECL_RPL (mktime, time_t, (struct tm *__tp) _GL_ARG_NONNULL ((1)));
_GL_CXXALIAS_RPL (mktime, time_t, (struct tm *__tp));
#  else
_GL_CXXALIAS_SYS (mktime, time_t, (struct tm *__tp));
#  endif
#  if __GLIBC__ >= 2
_GL_CXXALIASWARN (mktime);
#  endif
# elif defined GNULIB_POSIXCHECK
#  undef mktime
#  if HAVE_RAW_DECL_MKTIME
_GL_WARN_ON_USE (mktime, "mktime has portability problems - "
                 "use gnulib module mktime for portability");
#  endif
# endif

/* Convert TIMER to RESULT, assuming local time and UTC respectively.  See
   <https://pubs.opengroup.org/onlinepubs/9699919799/functions/localtime_r.html> and
   <https://pubs.opengroup.org/onlinepubs/9699919799/functions/gmtime_r.html>.  */
# if 0
#  if 0
#   if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#    undef localtime_r
#    define localtime_r rpl_localtime_r
#   endif
_GL_FUNCDECL_RPL (localtime_r, struct tm *, (time_t const *restrict __timer,
                                             struct tm *restrict __result)
                                            _GL_ARG_NONNULL ((1, 2)));
_GL_CXXALIAS_RPL (localtime_r, struct tm *, (time_t const *restrict __timer,
                                             struct tm *restrict __result));
#  else
#   if ! 1
_GL_FUNCDECL_SYS (localtime_r, struct tm *, (time_t const *restrict __timer,
                                             struct tm *restrict __result)
                                            _GL_ARG_NONNULL ((1, 2)));
#   endif
_GL_CXXALIAS_SYS (localtime_r, struct tm *, (time_t const *restrict __timer,
                                             struct tm *restrict __result));
#  endif
#  if 1
_GL_CXXALIASWARN (localtime_r);
#  endif
#  if 0
#   if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#    undef gmtime_r
#    define gmtime_r rpl_gmtime_r
#   endif
_GL_FUNCDECL_RPL (gmtime_r, struct tm *, (time_t const *restrict __timer,
                                          struct tm *restrict __result)
                                         _GL_ARG_NONNULL ((1, 2)));
_GL_CXXALIAS_RPL (gmtime_r, struct tm *, (time_t const *restrict __timer,
                                          struct tm *restrict __result));
#  else
#   if ! 1
_GL_FUNCDECL_SYS (gmtime_r, struct tm *, (time_t const *restrict __timer,
                                          struct tm *restrict __result)
                                         _GL_ARG_NONNULL ((1, 2)));
#   endif
_GL_CXXALIAS_SYS (gmtime_r, struct tm *, (time_t const *restrict __timer,
                                          struct tm *restrict __result));
#  endif
#  if 1
_GL_CXXALIASWARN (gmtime_r);
#  endif
# elif defined GNULIB_POSIXCHECK
#  undef localtime_r
#  if HAVE_RAW_DECL_LOCALTIME_R
_GL_WARN_ON_USE (localtime_r, "localtime_r is unportable - "
                 "use gnulib module time_r for portability");
#  endif
#  undef gmtime_r
#  if HAVE_RAW_DECL_GMTIME_R
_GL_WARN_ON_USE (gmtime_r, "gmtime_r is unportable - "
                 "use gnulib module time_r for portability");
#  endif
# endif

/* Convert TIMER to RESULT, assuming local time and UTC respectively.  See
   <https://pubs.opengroup.org/onlinepubs/9699919799/functions/localtime.html> and
   <https://pubs.opengroup.org/onlinepubs/9699919799/functions/gmtime.html>.  */
# if 1 || 0
#  if 0
#   if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#    undef localtime
#    define localtime rpl_localtime
#   endif
_GL_FUNCDECL_RPL (localtime, struct tm *, (time_t const *__timer)
                                          _GL_ARG_NONNULL ((1)));
_GL_CXXALIAS_RPL (localtime, struct tm *, (time_t const *__timer));
#  else
_GL_CXXALIAS_SYS (localtime, struct tm *, (time_t const *__timer));
#  endif
#  if __GLIBC__ >= 2
_GL_CXXALIASWARN (localtime);
#  endif
# elif defined GNULIB_POSIXCHECK
#  undef localtime
#  if HAVE_RAW_DECL_LOCALTIME
_GL_WARN_ON_USE (localtime, "localtime has portability problems - "
                 "use gnulib module localtime for portability");
#  endif
# endif

# if 0 || 0
#  if 0
#   if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#    undef gmtime
#    define gmtime rpl_gmtime
#   endif
_GL_FUNCDECL_RPL (gmtime, struct tm *, (time_t const *__timer)
                                       _GL_ARG_NONNULL ((1)));
_GL_CXXALIAS_RPL (gmtime, struct tm *, (time_t const *__timer));
#  else
_GL_CXXALIAS_SYS (gmtime, struct tm *, (time_t const *__timer));
#  endif
_GL_CXXALIASWARN (gmtime);
# endif

/* Parse BUF as a timestamp, assuming FORMAT specifies its layout, and store
   the resulting broken-down time into TM.  See
   <https://pubs.opengroup.org/onlinepubs/9699919799/functions/strptime.html>.  */
# if 0
#  if ! 1
_GL_FUNCDECL_SYS (strptime, char *, (char const *restrict __buf,
                                     char const *restrict __format,
                                     struct tm *restrict __tm)
                                    _GL_ARG_NONNULL ((1, 2, 3)));
#  endif
_GL_CXXALIAS_SYS (strptime, char *, (char const *restrict __buf,
                                     char const *restrict __format,
                                     struct tm *restrict __tm));
_GL_CXXALIASWARN (strptime);
# elif defined GNULIB_POSIXCHECK
#  undef strptime
#  if HAVE_RAW_DECL_STRPTIME
_GL_WARN_ON_USE (strptime, "strptime is unportable - "
                 "use gnulib module strptime for portability");
#  endif
# endif

/* Convert *TP to a date and time string.  See
   <https://pubs.opengroup.org/onlinepubs/9699919799/functions/ctime.html>.  */
# if 0
#  if 0
#   if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#    define ctime rpl_ctime
#   endif
#   ifndef __cplusplus
_GL_ATTRIBUTE_DEPRECATED
#   endif
_GL_FUNCDECL_RPL (ctime, char *, (time_t const *__tp)
                                 _GL_ARG_NONNULL ((1)));
_GL_CXXALIAS_RPL (ctime, char *, (time_t const *__tp));
#  else
_GL_CXXALIAS_SYS (ctime, char *, (time_t const *__tp));
#  endif
#  if __GLIBC__ >= 2
_GL_CXXALIASWARN (ctime);
#  endif
# elif defined GNULIB_POSIXCHECK
/* No need to warn about portability, as a more serious warning is below.  */
# endif

/* Convert *TP to a date and time string.  See
   <https://pubs.opengroup.org/onlinepubs/9699919799/functions/strftime.html>.  */
# if 0
#  if 0
#   if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#    define strftime rpl_strftime
#   endif
_GL_FUNCDECL_RPL (strftime, size_t,
                  (char *restrict __buf, size_t __bufsize,
                   const char *restrict __fmt, const struct tm *restrict __tp)
                  _GL_ARG_NONNULL ((1, 3, 4)));
_GL_CXXALIAS_RPL (strftime, size_t,
                  (char *restrict __buf, size_t __bufsize,
                   const char *restrict __fmt, const struct tm *restrict __tp));
#  else
_GL_CXXALIAS_SYS (strftime, size_t,
                  (char *restrict __buf, size_t __bufsize,
                   const char *restrict __fmt, const struct tm *restrict __tp));
#  endif
#  if __GLIBC__ >= 2
_GL_CXXALIASWARN (strftime);
#  endif
# elif defined GNULIB_POSIXCHECK
#  undef strftime
#  if HAVE_RAW_DECL_STRFTIME
_GL_WARN_ON_USE (strftime, "strftime has portability problems - "
                 "use gnulib module strftime-fixes for portability");
#  endif
# endif

# if defined _GNU_SOURCE && 0 && ! 0
/* Functions that use a first-class time zone data type, instead of
   relying on an implicit global time zone.
   Inspired by NetBSD.  */

/* Represents a time zone.
   (timezone_t) NULL stands for UTC.  */
typedef struct tm_zone *timezone_t;

/* tzalloc (name)
   Returns a time zone object for the given time zone NAME.  This object
   represents the time zone that other functions would use it the TZ
   environment variable was set to NAME.
   If NAME is NULL, the result represents the time zone that other functions
   would use it the TZ environment variable was unset.
   May return NULL if NAME is invalid (this is platform dependent) or
   upon memory allocation failure.  */
_GL_FUNCDECL_SYS (tzalloc, timezone_t, (char const *__name));
_GL_CXXALIAS_SYS (tzalloc, timezone_t, (char const *__name));

/* tzfree (tz)
   Frees a time zone object.
   The argument must have been returned by tzalloc().  */
_GL_FUNCDECL_SYS (tzfree, void, (timezone_t __tz));
_GL_CXXALIAS_SYS (tzfree, void, (timezone_t __tz));

/* localtime_rz (tz, &t, &result)
   Converts an absolute time T to a broken-down time RESULT, assuming the
   time zone TZ.
   This function is like 'localtime_r', but relies on the argument TZ instead
   of an implicit global time zone.  */
_GL_FUNCDECL_SYS (localtime_rz, struct tm *,
                  (timezone_t __tz, time_t const *restrict __timer,
                   struct tm *restrict __result) _GL_ARG_NONNULL ((2, 3)));
_GL_CXXALIAS_SYS (localtime_rz, struct tm *,
                  (timezone_t __tz, time_t const *restrict __timer,
                   struct tm *restrict __result));

/* mktime_z (tz, &tm)
   Normalizes the broken-down time TM and converts it to an absolute time,
   assuming the time zone TZ.  Returns the absolute time.
   This function is like 'mktime', but relies on the argument TZ instead
   of an implicit global time zone.  */
_GL_FUNCDECL_SYS (mktime_z, time_t,
                  (timezone_t __tz, struct tm *restrict __tm)
                  _GL_ARG_NONNULL ((2)));
_GL_CXXALIAS_SYS (mktime_z, time_t,
                  (timezone_t __tz, struct tm *restrict __tm));

/* Time zone abbreviation strings (returned by 'localtime_rz' or 'mktime_z'
   in the 'tm_zone' member of 'struct tm') are valid as long as
     - the 'struct tm' argument is not destroyed or overwritten,
   and
     - the 'timezone_t' argument is not freed through tzfree().  */

# endif

/* Convert TM to a time_t value, assuming UTC.  */
# if 0
#  if 0
#   if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#    undef timegm
#    define timegm rpl_timegm
#   endif
_GL_FUNCDECL_RPL (timegm, time_t, (struct tm *__tm) _GL_ARG_NONNULL ((1)));
_GL_CXXALIAS_RPL (timegm, time_t, (struct tm *__tm));
#  else
#   if ! 1
_GL_FUNCDECL_SYS (timegm, time_t, (struct tm *__tm) _GL_ARG_NONNULL ((1)));
#   endif
_GL_CXXALIAS_SYS (timegm, time_t, (struct tm *__tm));
#  endif
#  if __GLIBC__ >= 2
_GL_CXXALIASWARN (timegm);
#  endif
# elif defined GNULIB_POSIXCHECK
#  undef timegm
#  if HAVE_RAW_DECL_TIMEGM
_GL_WARN_ON_USE (timegm, "timegm is unportable - "
                 "use gnulib module timegm for portability");
#  endif
# endif

/* Encourage applications to avoid unsafe functions that can overrun
   buffers when given outlandish struct tm values.  Portable
   applications should use strftime (or even sprintf) instead.  */
# if defined GNULIB_POSIXCHECK
#  undef asctime
#  if HAVE_RAW_DECL_ASCTIME
_GL_WARN_ON_USE (asctime, "asctime can overrun buffers in some cases - "
                 "better use strftime (or even sprintf) instead");
#  endif
# endif
# if defined GNULIB_POSIXCHECK
#  undef asctime_r
#  if HAVE_RAW_DECL_ASCTIME_R
_GL_WARN_ON_USE (asctime_r, "asctime_r can overrun buffers in some cases - "
                 "better use strftime (or even sprintf) instead");
#  endif
# endif
# if defined GNULIB_POSIXCHECK
#  undef ctime
#  if HAVE_RAW_DECL_CTIME
_GL_WARN_ON_USE (ctime, "ctime can overrun buffers in some cases - "
                 "better use strftime (or even sprintf) instead");
#  endif
# endif
# if defined GNULIB_POSIXCHECK
#  undef ctime_r
#  if HAVE_RAW_DECL_CTIME_R
_GL_WARN_ON_USE (ctime_r, "ctime_r can overrun buffers in some cases - "
                 "better use strftime (or even sprintf) instead");
#  endif
# endif

#endif
