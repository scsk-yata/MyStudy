/* DO NOT EDIT! GENERATED AUTOMATICALLY! */
/* A substitute for ISO C99 <wchar.h>, for platforms that have issues.

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

/* Written by Eric Blake.  */

/*
 * ISO C 99 <wchar.h> for platforms that have issues.
 * <https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/wchar.h.html>
 *
 * For now, this just ensures proper prerequisite inclusion order and
 * the declaration of wcwidth().
 */

#if __GNUC__ >= 3
#pragma GCC system_header
#endif


#if (((defined __need_mbstate_t || defined __need_wint_t)               \
      && !defined __MINGW32__)                                          \
     || (defined __hpux                                                 \
         && ((defined _INTTYPES_INCLUDED                                \
              && !defined _GL_FINISHED_INCLUDING_SYSTEM_INTTYPES_H)     \
             || defined _GL_JUST_INCLUDE_SYSTEM_WCHAR_H))               \
     || (defined __MINGW32__ && defined __STRING_H_SOURCED__)           \
     || defined _GL_ALREADY_INCLUDING_WCHAR_H)
/* Special invocation convention:
   - Inside glibc and uClibc header files, but not MinGW.
   - On HP-UX 11.00 we have a sequence of nested includes
     <wchar.h> -> <stdlib.h> -> <stdint.h>, and the latter includes <wchar.h>,
     once indirectly <stdint.h> -> <sys/types.h> -> <inttypes.h> -> <wchar.h>
     and once directly.  In both situations 'wint_t' is not yet defined,
     therefore we cannot provide the function overrides; instead include only
     the system's <wchar.h>.
   - With MinGW 3.22, when <string.h> includes <wchar.h>, only some part of
     <wchar.h> is actually processed, and that doesn't include 'mbstate_t'.
   - On IRIX 6.5, similarly, we have an include <wchar.h> -> <wctype.h>, and
     the latter includes <wchar.h>.  But here, we have no way to detect whether
     <wctype.h> is completely included or is still being included.  */

#include_next <wchar.h>

#else
/* Normal invocation convention.  */

#ifndef _GL_WCHAR_H

#define _GL_ALREADY_INCLUDING_WCHAR_H

#if 1
# include <features.h> /* for __GLIBC__ */
#endif

/* In some builds of uClibc, <wchar.h> is nonexistent and wchar_t is defined
   by <stddef.h>.
   But avoid namespace pollution on glibc systems.  */
#if !(defined __GLIBC__ && !defined __UCLIBC__)
# include <stddef.h>
#endif

/* Include the original <wchar.h> if it exists.
   Some builds of uClibc lack it.  */
/* The include_next requires a split double-inclusion guard.  */
#if 1
# include_next <wchar.h>
#endif

#undef _GL_ALREADY_INCLUDING_WCHAR_H

#ifndef _GL_WCHAR_H
#define _GL_WCHAR_H

/* This file uses _GL_ATTRIBUTE_DEALLOC, _GL_ATTRIBUTE_MALLOC,
   _GL_ATTRIBUTE_NOTHROW, _GL_ATTRIBUTE_PURE, GNULIB_POSIXCHECK,
   HAVE_RAW_DECL_*.  */
#if !_GL_CONFIG_H_INCLUDED
 #error "Please include config.h first."
#endif

/* _GL_ATTRIBUTE_DEALLOC (F, I) declares that the function returns pointers
   that can be freed by passing them as the Ith argument to the
   function F.  */
#ifndef _GL_ATTRIBUTE_DEALLOC
# if __GNUC__ >= 11
#  define _GL_ATTRIBUTE_DEALLOC(f, i) __attribute__ ((__malloc__ (f, i)))
# else
#  define _GL_ATTRIBUTE_DEALLOC(f, i)
# endif
#endif

/* _GL_ATTRIBUTE_DEALLOC_FREE declares that the function returns pointers that
   can be freed via 'free'; it can be used only after declaring 'free'.  */
/* Applies to: functions.  Cannot be used on inline functions.  */
#ifndef _GL_ATTRIBUTE_DEALLOC_FREE
# if defined __cplusplus && defined __GNUC__ && !defined __clang__
/* Work around GCC bug <https://gcc.gnu.org/bugzilla/show_bug.cgi?id=108231> */
#  define _GL_ATTRIBUTE_DEALLOC_FREE \
     _GL_ATTRIBUTE_DEALLOC ((void (*) (void *)) free, 1)
# else
#  define _GL_ATTRIBUTE_DEALLOC_FREE \
     _GL_ATTRIBUTE_DEALLOC (free, 1)
# endif
#endif

/* _GL_ATTRIBUTE_MALLOC declares that the function returns a pointer to freshly
   allocated memory.  */
/* Applies to: functions.  */
#ifndef _GL_ATTRIBUTE_MALLOC
# if __GNUC__ >= 3 || defined __clang__
#  define _GL_ATTRIBUTE_MALLOC __attribute__ ((__malloc__))
# else
#  define _GL_ATTRIBUTE_MALLOC
# endif
#endif

/* The __attribute__ feature is available in gcc versions 2.5 and later.
   The attribute __pure__ was added in gcc 2.96.  */
#ifndef _GL_ATTRIBUTE_PURE
# if __GNUC__ > 2 || (__GNUC__ == 2 && __GNUC_MINOR__ >= 96) || defined __clang__
#  define _GL_ATTRIBUTE_PURE __attribute__ ((__pure__))
# else
#  define _GL_ATTRIBUTE_PURE /* empty */
# endif
#endif

/* _GL_ATTRIBUTE_NOTHROW declares that the function does not throw exceptions.
 */
#ifndef _GL_ATTRIBUTE_NOTHROW
# if defined __cplusplus
#  if (__GNUC__ + (__GNUC_MINOR__ >= 8) > 2) || __clang_major >= 4
#   if __cplusplus >= 201103L
#    define _GL_ATTRIBUTE_NOTHROW noexcept (true)
#   else
#    define _GL_ATTRIBUTE_NOTHROW throw ()
#   endif
#  else
#   define _GL_ATTRIBUTE_NOTHROW
#  endif
# else
#  if (__GNUC__ + (__GNUC_MINOR__ >= 3) > 3) || defined __clang__
#   define _GL_ATTRIBUTE_NOTHROW __attribute__ ((__nothrow__))
#  else
#   define _GL_ATTRIBUTE_NOTHROW
#  endif
# endif
#endif

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


/* Define wint_t and WEOF.  (Also done in wctype.in.h.)  */
#if !1 && !defined wint_t
# define wint_t int
# ifndef WEOF
#  define WEOF -1
# endif
#else
/* mingw and MSVC define wint_t as 'unsigned short' in <crtdefs.h> or
   <stddef.h>.  This is too small: ISO C 99 section 7.24.1.(2) says that
   wint_t must be "unchanged by default argument promotions".  Override it.  */
# if 0
#  if !GNULIB_defined_wint_t
#   if 0
#    include <crtdefs.h>
#   else
#    include <stddef.h>
#   endif
typedef unsigned int rpl_wint_t;
#   undef wint_t
#   define wint_t rpl_wint_t
#   define GNULIB_defined_wint_t 1
#  endif
# endif
# ifndef WEOF
#  define WEOF ((wint_t) -1)
# endif
#endif


/* Override mbstate_t if it is too small.
   On IRIX 6.5, sizeof (mbstate_t) == 1, which is not sufficient for
   implementing mbrtowc for encodings like UTF-8.
   On AIX and MSVC, mbrtowc needs to be overridden, but mbstate_t exists and is
   large enough and overriding it would cause problems in C++ mode.  */
#if !(((defined _WIN32 && !defined __CYGWIN__) || 1) && 1) || 0
# if !GNULIB_defined_mbstate_t
#  if !(defined _AIX || defined _MSC_VER)
typedef int rpl_mbstate_t;
#   undef mbstate_t
#   define mbstate_t rpl_mbstate_t
#  endif
#  define GNULIB_defined_mbstate_t 1
# endif
#endif

/* Make _GL_ATTRIBUTE_DEALLOC_FREE work, even though <stdlib.h> may not have
   been included yet.  */
#if 1
# if (0 && !defined free \
      && !(defined __cplusplus && defined GNULIB_NAMESPACE))
/* We can't do '#define free rpl_free' here.  */
#  if defined __cplusplus && (__GLIBC__ + (__GLIBC_MINOR__ >= 14) > 2)
_GL_EXTERN_C void rpl_free (void *) _GL_ATTRIBUTE_NOTHROW;
#  else
_GL_EXTERN_C void rpl_free (void *);
#  endif
#  undef _GL_ATTRIBUTE_DEALLOC_FREE
#  define _GL_ATTRIBUTE_DEALLOC_FREE _GL_ATTRIBUTE_DEALLOC (rpl_free, 1)
# else
#  if defined _MSC_VER && !defined free
_GL_EXTERN_C
#   if defined _DLL
     __declspec (dllimport)
#   endif
     void __cdecl free (void *);
#  else
#   if defined __cplusplus && (__GLIBC__ + (__GLIBC_MINOR__ >= 14) > 2)
_GL_EXTERN_C void free (void *) _GL_ATTRIBUTE_NOTHROW;
#   else
_GL_EXTERN_C void free (void *);
#   endif
#  endif
# endif
#else
# if defined _MSC_VER && !defined free
_GL_EXTERN_C
#   if defined _DLL
     __declspec (dllimport)
#   endif
     void __cdecl free (void *);
# else
#  if defined __cplusplus && (__GLIBC__ + (__GLIBC_MINOR__ >= 14) > 2)
_GL_EXTERN_C void free (void *) _GL_ATTRIBUTE_NOTHROW;
#  else
_GL_EXTERN_C void free (void *);
#  endif
# endif
#endif


#if 1
/* Get memset().  */
# include <string.h>
#endif


/* Convert a single-byte character to a wide character.  */
#if 1
# if 1
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef btowc
#   define btowc rpl_btowc
#  endif
_GL_FUNCDECL_RPL (btowc, wint_t, (int c) _GL_ATTRIBUTE_PURE);
_GL_CXXALIAS_RPL (btowc, wint_t, (int c));
# else
#  if !1
_GL_FUNCDECL_SYS (btowc, wint_t, (int c) _GL_ATTRIBUTE_PURE);
#  endif
/* Need to cast, because on mingw, the return type is 'unsigned short'.  */
_GL_CXXALIAS_SYS_CAST (btowc, wint_t, (int c));
# endif
# if __GLIBC__ >= 2
_GL_CXXALIASWARN (btowc);
# endif
#elif defined GNULIB_POSIXCHECK
# undef btowc
# if HAVE_RAW_DECL_BTOWC
_GL_WARN_ON_USE (btowc, "btowc is unportable - "
                 "use gnulib module btowc for portability");
# endif
#endif


/* Convert a wide character to a single-byte character.  */
#if IN_GETTEXT_TOOLS_GNULIB_TESTS
# if 0
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef wctob
#   define wctob rpl_wctob
#  endif
_GL_FUNCDECL_RPL (wctob, int, (wint_t wc) _GL_ATTRIBUTE_PURE);
_GL_CXXALIAS_RPL (wctob, int, (wint_t wc));
# else
#  if !defined wctob && !1
/* wctob is provided by gnulib, or wctob exists but is not declared.  */
_GL_FUNCDECL_SYS (wctob, int, (wint_t wc) _GL_ATTRIBUTE_PURE);
#  endif
_GL_CXXALIAS_SYS (wctob, int, (wint_t wc));
# endif
# if __GLIBC__ >= 2
_GL_CXXALIASWARN (wctob);
# endif
#elif defined GNULIB_POSIXCHECK
# undef wctob
# if HAVE_RAW_DECL_WCTOB
_GL_WARN_ON_USE (wctob, "wctob is unportable - "
                 "use gnulib module wctob for portability");
# endif
#endif


/* Test whether *PS is in an initial state.  */
#if 1
# if 0
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef mbsinit
#   define mbsinit rpl_mbsinit
#  endif
_GL_FUNCDECL_RPL (mbsinit, int, (const mbstate_t *ps));
_GL_CXXALIAS_RPL (mbsinit, int, (const mbstate_t *ps));
# else
#  if !1
_GL_FUNCDECL_SYS (mbsinit, int, (const mbstate_t *ps));
#  endif
_GL_CXXALIAS_SYS (mbsinit, int, (const mbstate_t *ps));
# endif
# if __GLIBC__ >= 2
_GL_CXXALIASWARN (mbsinit);
# endif
#elif defined GNULIB_POSIXCHECK
# undef mbsinit
# if HAVE_RAW_DECL_MBSINIT
_GL_WARN_ON_USE (mbsinit, "mbsinit is unportable - "
                 "use gnulib module mbsinit for portability");
# endif
#endif


/* Put *PS into an initial state.  */
#if 1
/* ISO C 23 § 7.31.6.(3) says that zeroing an mbstate_t is a way to put the
   mbstate_t into an initial state.  However, on many platforms an mbstate_t
   is large, and it is possible - as an optimization - to get away with zeroing
   only part of it.  So, instead of

        mbstate_t state = { 0 };

   or

        mbstate_t state;
        memset (&state, 0, sizeof (mbstate_t));

   we can write this faster code:

        mbstate_t state;
        mbszero (&state);
 */
/* _GL_MBSTATE_INIT_SIZE describes how mbsinit() behaves: It is the number of
   bytes at the beginning of an mbstate_t that need to be zero, for mbsinit()
   to return true.
   _GL_MBSTATE_ZERO_SIZE is the number of bytes at the beginning of an mbstate_t
   that need to be zero,
     - for mbsinit() to return true, and
     - for all other multibyte-aware functions to operate properly.
   0 < _GL_MBSTATE_INIT_SIZE <= _GL_MBSTATE_ZERO_SIZE <= sizeof (mbstate_t).
   These values are determined by source code inspection, where possible, and
   by running the gnulib unit tests.
   We need _GL_MBSTATE_INIT_SIZE because if we define _GL_MBSTATE_ZERO_SIZE
   without considering what mbsinit() does, we get test failures such as
     assertion "mbsinit (&iter->state)" failed
 */
# if GNULIB_defined_mbstate_t                             /* AIX, IRIX */
/* mbstate_t has at least 4 bytes.  They are used as coded in
   gnulib/lib/mbrtowc.c.  */
#  define _GL_MBSTATE_INIT_SIZE 1
/* define _GL_MBSTATE_ZERO_SIZE 4
   does not work: it causes test failures.
   So, use the safe fallback value, below.  */
# elif __GLIBC__ + (__GLIBC_MINOR__ >= 2) > 2             /* glibc */
/* mbstate_t is defined in <bits/types/__mbstate_t.h>.
   For more details, see glibc/iconv/skeleton.c.  */
#  define _GL_MBSTATE_INIT_SIZE 4 /* sizeof (((mbstate_t) {0}).__count) */
#  define _GL_MBSTATE_ZERO_SIZE /* 8 */ sizeof (mbstate_t)
# elif defined MUSL_LIBC                                  /* musl libc */
/* mbstate_t is defined in <bits/alltypes.h>.
   It is an opaque aligned 8-byte struct, of which at most the first
   4 bytes are used.
   For more details, see src/multibyte/mbrtowc.c.  */
#  define _GL_MBSTATE_INIT_SIZE 4 /* sizeof (unsigned) */
#  define _GL_MBSTATE_ZERO_SIZE 4
# elif defined __APPLE__ && defined __MACH__              /* macOS */
/* On macOS, mbstate_t is defined in <machine/_types.h>.
   It is an opaque aligned 128-byte struct, of which at most the first
   12 bytes are used.
   For more details, see the __mbsinit implementations in
   Libc-<version>/locale/FreeBSD/
   {ascii,none,euc,mskanji,big5,gb2312,gbk,gb18030,utf8,utf2}.c.  */
/* File       INIT_SIZE  ZERO_SIZE
   ascii.c        0          0
   none.c         0          0
   euc.c         12         12
   mskanji.c      4          4
   big5.c         4          4
   gb2312.c       4          6
   gbk.c          4          4
   gb18030.c      4          8
   utf8.c         8         10
   utf2.c         8         12 */
#  define _GL_MBSTATE_INIT_SIZE 12
#  define _GL_MBSTATE_ZERO_SIZE 12
# elif defined __FreeBSD__                                /* FreeBSD */
/* On FreeBSD, mbstate_t is defined in src/sys/sys/_types.h.
   It is an opaque aligned 128-byte struct, of which at most the first
   12 bytes are used.
   For more details, see the __mbsinit implementations in
   src/lib/libc/locale/
   {ascii,none,euc,mskanji,big5,gb2312,gbk,gb18030,utf8}.c.  */
/* File       INIT_SIZE  ZERO_SIZE
   ascii.c        0          0
   none.c         0          0
   euc.c         12         12
   mskanji.c      4          4
   big5.c         4          4
   gb2312.c       4          6
   gbk.c          4          4
   gb18030.c      4          8
   utf8.c         8         12 */
#  define _GL_MBSTATE_INIT_SIZE 12
#  define _GL_MBSTATE_ZERO_SIZE 12
# elif defined __NetBSD__                                 /* NetBSD */
/* On NetBSD, mbstate_t is defined in src/sys/sys/ansi.h.
   It is an opaque aligned 128-byte struct, of which at most the first
   28 bytes are used.
   For more details, see the *State types in
   src/lib/libc/citrus/modules/citrus_*.c
   (ignoring citrus_{hz,iso2022,utf7,viqr,zw}.c, since these implement
   stateful encodings, not usable as locale encodings).  */
/* File                                ZERO_SIZE
   citrus/citrus_none.c                    0
   citrus/modules/citrus_euc.c             8
   citrus/modules/citrus_euctw.c           8
   citrus/modules/citrus_mskanji.c         8
   citrus/modules/citrus_big5.c            8
   citrus/modules/citrus_gbk2k.c           8
   citrus/modules/citrus_dechanyu.c        8
   citrus/modules/citrus_johab.c           6
   citrus/modules/citrus_utf8.c           12 */
/* But 12 is not the correct value for _GL_MBSTATE_ZERO_SIZE: we get test
   failures for values < 28.  */
#  define _GL_MBSTATE_ZERO_SIZE 28
# elif defined __OpenBSD__                                /* OpenBSD */
/* On OpenBSD, mbstate_t is defined in src/sys/sys/_types.h.
   It is an opaque aligned 128-byte struct, of which at most the first
   12 bytes are used.
   For more details, see src/lib/libc/citrus/citrus_*.c.  */
/* File           INIT_SIZE  ZERO_SIZE
   citrus_none.c      0          0
   citrus_utf8.c     12         12 */
#  define _GL_MBSTATE_INIT_SIZE 12
#  define _GL_MBSTATE_ZERO_SIZE 12
# elif defined __minix                                    /* Minix */
/* On Minix, mbstate_t is defined in sys/sys/ansi.h.
   It is an opaque aligned 128-byte struct.
   For more details, see the *State types in
   lib/libc/citrus/citrus_*.c.  */
/* File           INIT_SIZE  ZERO_SIZE
   citrus_none.c      0          0 */
/* But 1 is not the correct value for _GL_MBSTATE_ZERO_SIZE: we get test
   failures for values < 4.  */
#  define _GL_MBSTATE_ZERO_SIZE 4
# elif defined __sun                                      /* Solaris */
/* On Solaris, mbstate_t is defined in <wchar_impl.h>.
   It is an opaque aligned 24-byte or 32-byte struct, of which at most the first
   20 or 28 bytes are used.
   For more details on OpenSolaris derivatives, see the *State types in
   illumos-gate/usr/src/lib/libc/port/locale/
   {none,euc,mskanji,big5,gb2312,gbk,gb18030,utf8}.c.  */
/* File       INIT_SIZE  ZERO_SIZE
   none.c         0          0
   euc.c         12         12
   mskanji.c      4          4
   big5.c         4          4
   gb2312.c       4          6
   gbk.c          4          4
   gb18030.c      4          8
   utf8.c        12         12 */
/* But 12 is not the correct value for _GL_MBSTATE_ZERO_SIZE: we get test
   failures
     - in OpenIndiana and OmniOS: for values < 16,
     - in Solaris 10 and 11: for values < 20 (in 32-bit mode)
       or < 28 (in 64-bit mode).
   Since we don't have a good way to distinguish the OpenSolaris derivatives
   from the proprietary Solaris versions, and can't inspect the Solaris source
   code, use the safe fallback values, below.  */
# elif defined __CYGWIN__                                 /* Cygwin */
/* On Cygwin, mbstate_t is defined in <sys/_types.h>.
   For more details, see newlib/libc/stdlib/mbtowc_r.c and
   winsup/cygwin/strfuncs.cc.  */
#  define _GL_MBSTATE_INIT_SIZE 4 /* sizeof (int) */
#  define _GL_MBSTATE_ZERO_SIZE 8
# elif defined _WIN32 && !defined __CYGWIN__              /* Native Windows.  */
/* MSVC defines 'mbstate_t' as an aligned 8-byte struct.
   On mingw, 'mbstate_t' is sometimes defined as 'int', sometimes defined
   as an aligned 8-byte struct, of which the first 4 bytes matter.
   Use the safe values, below.  */
# elif defined __ANDROID__                                /* Android */
/* Android defines 'mbstate_t' in <bits/mbstate_t.h>.
   It is an opaque 4-byte or 8-byte struct.
   For more details, see
   bionic/libc/private/bionic_mbstate.h
   bionic/libc/bionic/mbrtoc32.cpp
   bionic/libc/bionic/mbrtoc16.cpp
 */
#  define _GL_MBSTATE_INIT_SIZE 4
#  define _GL_MBSTATE_ZERO_SIZE 4
# endif
/* Use safe values as defaults.  */
# ifndef _GL_MBSTATE_INIT_SIZE
#  define _GL_MBSTATE_INIT_SIZE sizeof (mbstate_t)
# endif
# ifndef _GL_MBSTATE_ZERO_SIZE
#  define _GL_MBSTATE_ZERO_SIZE sizeof (mbstate_t)
# endif
_GL_BEGIN_C_LINKAGE
# if defined IN_MBSZERO
_GL_EXTERN_INLINE
# else
_GL_INLINE
# endif
_GL_ARG_NONNULL ((1)) void
mbszero (mbstate_t *ps)
{
  memset (ps, 0, _GL_MBSTATE_ZERO_SIZE);
}
_GL_END_C_LINKAGE
_GL_CXXALIAS_SYS (mbszero, void, (mbstate_t *ps));
_GL_CXXALIASWARN (mbszero);
#endif


/* Convert a multibyte character to a wide character.  */
#if 1
# if 1
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef mbrtowc
#   define mbrtowc rpl_mbrtowc
#  endif
_GL_FUNCDECL_RPL (mbrtowc, size_t,
                  (wchar_t *restrict pwc, const char *restrict s, size_t n,
                   mbstate_t *restrict ps));
_GL_CXXALIAS_RPL (mbrtowc, size_t,
                  (wchar_t *restrict pwc, const char *restrict s, size_t n,
                   mbstate_t *restrict ps));
# else
#  if !1
_GL_FUNCDECL_SYS (mbrtowc, size_t,
                  (wchar_t *restrict pwc, const char *restrict s, size_t n,
                   mbstate_t *restrict ps));
#  endif
_GL_CXXALIAS_SYS (mbrtowc, size_t,
                  (wchar_t *restrict pwc, const char *restrict s, size_t n,
                   mbstate_t *restrict ps));
# endif
# if __GLIBC__ >= 2
_GL_CXXALIASWARN (mbrtowc);
# endif
#elif defined GNULIB_POSIXCHECK
# undef mbrtowc
# if HAVE_RAW_DECL_MBRTOWC
_GL_WARN_ON_USE (mbrtowc, "mbrtowc is unportable - "
                 "use gnulib module mbrtowc for portability");
# endif
#endif


/* Recognize a multibyte character.  */
#if 0
# if 1
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef mbrlen
#   define mbrlen rpl_mbrlen
#  endif
_GL_FUNCDECL_RPL (mbrlen, size_t,
                  (const char *restrict s, size_t n, mbstate_t *restrict ps));
_GL_CXXALIAS_RPL (mbrlen, size_t,
                  (const char *restrict s, size_t n, mbstate_t *restrict ps));
# else
#  if !1
_GL_FUNCDECL_SYS (mbrlen, size_t,
                  (const char *restrict s, size_t n, mbstate_t *restrict ps));
#  endif
_GL_CXXALIAS_SYS (mbrlen, size_t,
                  (const char *restrict s, size_t n, mbstate_t *restrict ps));
# endif
# if __GLIBC__ >= 2
_GL_CXXALIASWARN (mbrlen);
# endif
#elif defined GNULIB_POSIXCHECK
# undef mbrlen
# if HAVE_RAW_DECL_MBRLEN
_GL_WARN_ON_USE (mbrlen, "mbrlen is unportable - "
                 "use gnulib module mbrlen for portability");
# endif
#endif


/* Convert a string to a wide string.  */
#if 1
# if 1
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef mbsrtowcs
#   define mbsrtowcs rpl_mbsrtowcs
#  endif
_GL_FUNCDECL_RPL (mbsrtowcs, size_t,
                  (wchar_t *restrict dest,
                   const char **restrict srcp, size_t len,
                   mbstate_t *restrict ps)
                  _GL_ARG_NONNULL ((2)));
_GL_CXXALIAS_RPL (mbsrtowcs, size_t,
                  (wchar_t *restrict dest,
                   const char **restrict srcp, size_t len,
                   mbstate_t *restrict ps));
# else
#  if !1
_GL_FUNCDECL_SYS (mbsrtowcs, size_t,
                  (wchar_t *restrict dest,
                   const char **restrict srcp, size_t len,
                   mbstate_t *restrict ps)
                  _GL_ARG_NONNULL ((2)));
#  endif
_GL_CXXALIAS_SYS (mbsrtowcs, size_t,
                  (wchar_t *restrict dest,
                   const char **restrict srcp, size_t len,
                   mbstate_t *restrict ps));
# endif
# if __GLIBC__ >= 2
_GL_CXXALIASWARN (mbsrtowcs);
# endif
#elif defined GNULIB_POSIXCHECK
# undef mbsrtowcs
# if HAVE_RAW_DECL_MBSRTOWCS
_GL_WARN_ON_USE (mbsrtowcs, "mbsrtowcs is unportable - "
                 "use gnulib module mbsrtowcs for portability");
# endif
#endif


/* Convert a string to a wide string.  */
#if 0
# if 0
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef mbsnrtowcs
#   define mbsnrtowcs rpl_mbsnrtowcs
#  endif
_GL_FUNCDECL_RPL (mbsnrtowcs, size_t,
                  (wchar_t *restrict dest,
                   const char **restrict srcp, size_t srclen, size_t len,
                   mbstate_t *restrict ps)
                  _GL_ARG_NONNULL ((2)));
_GL_CXXALIAS_RPL (mbsnrtowcs, size_t,
                  (wchar_t *restrict dest,
                   const char **restrict srcp, size_t srclen, size_t len,
                   mbstate_t *restrict ps));
# else
#  if !1
_GL_FUNCDECL_SYS (mbsnrtowcs, size_t,
                  (wchar_t *restrict dest,
                   const char **restrict srcp, size_t srclen, size_t len,
                   mbstate_t *restrict ps)
                  _GL_ARG_NONNULL ((2)));
#  endif
_GL_CXXALIAS_SYS (mbsnrtowcs, size_t,
                  (wchar_t *restrict dest,
                   const char **restrict srcp, size_t srclen, size_t len,
                   mbstate_t *restrict ps));
# endif
# if __GLIBC__ >= 2
_GL_CXXALIASWARN (mbsnrtowcs);
# endif
#elif defined GNULIB_POSIXCHECK
# undef mbsnrtowcs
# if HAVE_RAW_DECL_MBSNRTOWCS
_GL_WARN_ON_USE (mbsnrtowcs, "mbsnrtowcs is unportable - "
                 "use gnulib module mbsnrtowcs for portability");
# endif
#endif


/* Convert a wide character to a multibyte character.  */
#if IN_GETTEXT_TOOLS_GNULIB_TESTS
# if 0
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef wcrtomb
#   define wcrtomb rpl_wcrtomb
#  endif
_GL_FUNCDECL_RPL (wcrtomb, size_t,
                  (char *restrict s, wchar_t wc, mbstate_t *restrict ps));
_GL_CXXALIAS_RPL (wcrtomb, size_t,
                  (char *restrict s, wchar_t wc, mbstate_t *restrict ps));
# else
#  if !1
_GL_FUNCDECL_SYS (wcrtomb, size_t,
                  (char *restrict s, wchar_t wc, mbstate_t *restrict ps));
#  endif
_GL_CXXALIAS_SYS (wcrtomb, size_t,
                  (char *restrict s, wchar_t wc, mbstate_t *restrict ps));
# endif
# if __GLIBC__ >= 2
_GL_CXXALIASWARN (wcrtomb);
# endif
#elif defined GNULIB_POSIXCHECK
# undef wcrtomb
# if HAVE_RAW_DECL_WCRTOMB
_GL_WARN_ON_USE (wcrtomb, "wcrtomb is unportable - "
                 "use gnulib module wcrtomb for portability");
# endif
#endif


/* Convert a wide string to a string.  */
#if 0
# if 0
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef wcsrtombs
#   define wcsrtombs rpl_wcsrtombs
#  endif
_GL_FUNCDECL_RPL (wcsrtombs, size_t,
                  (char *restrict dest, const wchar_t **restrict srcp,
                   size_t len,
                   mbstate_t *restrict ps)
                  _GL_ARG_NONNULL ((2)));
_GL_CXXALIAS_RPL (wcsrtombs, size_t,
                  (char *restrict dest, const wchar_t **restrict srcp,
                   size_t len,
                   mbstate_t *restrict ps));
# else
#  if !1
_GL_FUNCDECL_SYS (wcsrtombs, size_t,
                  (char *restrict dest, const wchar_t **restrict srcp,
                   size_t len,
                   mbstate_t *restrict ps)
                  _GL_ARG_NONNULL ((2)));
#  endif
_GL_CXXALIAS_SYS (wcsrtombs, size_t,
                  (char *restrict dest, const wchar_t **restrict srcp,
                   size_t len,
                   mbstate_t *restrict ps));
# endif
# if __GLIBC__ >= 2
_GL_CXXALIASWARN (wcsrtombs);
# endif
#elif defined GNULIB_POSIXCHECK
# undef wcsrtombs
# if HAVE_RAW_DECL_WCSRTOMBS
_GL_WARN_ON_USE (wcsrtombs, "wcsrtombs is unportable - "
                 "use gnulib module wcsrtombs for portability");
# endif
#endif


/* Convert a wide string to a string.  */
#if 0
# if 0
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef wcsnrtombs
#   define wcsnrtombs rpl_wcsnrtombs
#  endif
_GL_FUNCDECL_RPL (wcsnrtombs, size_t,
                  (char *restrict dest,
                   const wchar_t **restrict srcp, size_t srclen,
                   size_t len,
                   mbstate_t *restrict ps)
                  _GL_ARG_NONNULL ((2)));
_GL_CXXALIAS_RPL (wcsnrtombs, size_t,
                  (char *restrict dest,
                   const wchar_t **restrict srcp, size_t srclen,
                   size_t len,
                   mbstate_t *restrict ps));
# else
#  if !1 || (defined __cplusplus && defined __sun)
_GL_FUNCDECL_SYS (wcsnrtombs, size_t,
                  (char *restrict dest,
                   const wchar_t **restrict srcp, size_t srclen,
                   size_t len,
                   mbstate_t *restrict ps)
                  _GL_ARG_NONNULL ((2)));
#  endif
_GL_CXXALIAS_SYS (wcsnrtombs, size_t,
                  (char *restrict dest,
                   const wchar_t **restrict srcp, size_t srclen,
                   size_t len,
                   mbstate_t *restrict ps));
# endif
# if __GLIBC__ >= 2
_GL_CXXALIASWARN (wcsnrtombs);
# endif
#elif defined GNULIB_POSIXCHECK
# undef wcsnrtombs
# if HAVE_RAW_DECL_WCSNRTOMBS
_GL_WARN_ON_USE (wcsnrtombs, "wcsnrtombs is unportable - "
                 "use gnulib module wcsnrtombs for portability");
# endif
#endif


/* Return the number of screen columns needed for WC.  */
#if 1
# if 0
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef wcwidth
#   define wcwidth rpl_wcwidth
#  endif
_GL_FUNCDECL_RPL (wcwidth, int, (wchar_t) _GL_ATTRIBUTE_PURE);
_GL_CXXALIAS_RPL (wcwidth, int, (wchar_t));
# else
#  if !1
/* wcwidth exists but is not declared.  */
_GL_FUNCDECL_SYS (wcwidth, int, (wchar_t) _GL_ATTRIBUTE_PURE);
#  endif
_GL_CXXALIAS_SYS (wcwidth, int, (wchar_t));
# endif
# if __GLIBC__ >= 2
_GL_CXXALIASWARN (wcwidth);
# endif
#elif defined GNULIB_POSIXCHECK
# undef wcwidth
# if HAVE_RAW_DECL_WCWIDTH
_GL_WARN_ON_USE (wcwidth, "wcwidth is unportable - "
                 "use gnulib module wcwidth for portability");
# endif
#endif


/* Search N wide characters of S for C.  */
#if 1
# if !1
_GL_FUNCDECL_SYS (wmemchr, wchar_t *, (const wchar_t *s, wchar_t c, size_t n)
                                      _GL_ATTRIBUTE_PURE);
# endif
  /* On some systems, this function is defined as an overloaded function:
       extern "C++" {
         const wchar_t * std::wmemchr (const wchar_t *, wchar_t, size_t);
         wchar_t * std::wmemchr (wchar_t *, wchar_t, size_t);
       }  */
_GL_CXXALIAS_SYS_CAST2 (wmemchr,
                        wchar_t *, (const wchar_t *, wchar_t, size_t),
                        const wchar_t *, (const wchar_t *, wchar_t, size_t));
# if ((__GLIBC__ == 2 && __GLIBC_MINOR__ >= 10) && !defined __UCLIBC__) \
     && (__GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 4))
_GL_CXXALIASWARN1 (wmemchr, wchar_t *, (wchar_t *s, wchar_t c, size_t n));
_GL_CXXALIASWARN1 (wmemchr, const wchar_t *,
                   (const wchar_t *s, wchar_t c, size_t n));
# elif __GLIBC__ >= 2
_GL_CXXALIASWARN (wmemchr);
# endif
#elif defined GNULIB_POSIXCHECK
# undef wmemchr
# if HAVE_RAW_DECL_WMEMCHR
_GL_WARN_ON_USE (wmemchr, "wmemchr is unportable - "
                 "use gnulib module wmemchr for portability");
# endif
#endif


/* Compare N wide characters of S1 and S2.  */
#if 0
# if 0
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef wmemcmp
#   define wmemcmp rpl_wmemcmp
#  endif
_GL_FUNCDECL_RPL (wmemcmp, int,
                  (const wchar_t *s1, const wchar_t *s2, size_t n)
                  _GL_ATTRIBUTE_PURE);
_GL_CXXALIAS_RPL (wmemcmp, int,
                  (const wchar_t *s1, const wchar_t *s2, size_t n));
# else
#  if !1
_GL_FUNCDECL_SYS (wmemcmp, int,
                  (const wchar_t *s1, const wchar_t *s2, size_t n)
                  _GL_ATTRIBUTE_PURE);
#  endif
_GL_CXXALIAS_SYS (wmemcmp, int,
                  (const wchar_t *s1, const wchar_t *s2, size_t n));
# endif
# if __GLIBC__ >= 2
_GL_CXXALIASWARN (wmemcmp);
# endif
#elif defined GNULIB_POSIXCHECK
# undef wmemcmp
# if HAVE_RAW_DECL_WMEMCMP
_GL_WARN_ON_USE (wmemcmp, "wmemcmp is unportable - "
                 "use gnulib module wmemcmp for portability");
# endif
#endif


/* Copy N wide characters of SRC to DEST.  */
#if 0
# if !1
_GL_FUNCDECL_SYS (wmemcpy, wchar_t *,
                  (wchar_t *restrict dest,
                   const wchar_t *restrict src, size_t n));
# endif
_GL_CXXALIAS_SYS (wmemcpy, wchar_t *,
                  (wchar_t *restrict dest,
                   const wchar_t *restrict src, size_t n));
# if __GLIBC__ >= 2
_GL_CXXALIASWARN (wmemcpy);
# endif
#elif defined GNULIB_POSIXCHECK
# undef wmemcpy
# if HAVE_RAW_DECL_WMEMCPY
_GL_WARN_ON_USE (wmemcpy, "wmemcpy is unportable - "
                 "use gnulib module wmemcpy for portability");
# endif
#endif


/* Copy N wide characters of SRC to DEST, guaranteeing correct behavior for
   overlapping memory areas.  */
#if 0
# if !1
_GL_FUNCDECL_SYS (wmemmove, wchar_t *,
                  (wchar_t *dest, const wchar_t *src, size_t n));
# endif
_GL_CXXALIAS_SYS (wmemmove, wchar_t *,
                  (wchar_t *dest, const wchar_t *src, size_t n));
# if __GLIBC__ >= 2
_GL_CXXALIASWARN (wmemmove);
# endif
#elif defined GNULIB_POSIXCHECK
# undef wmemmove
# if HAVE_RAW_DECL_WMEMMOVE
_GL_WARN_ON_USE (wmemmove, "wmemmove is unportable - "
                 "use gnulib module wmemmove for portability");
# endif
#endif


/* Copy N wide characters of SRC to DEST.
   Return pointer to wide characters after the last written wide character.  */
#if 1
# if 0
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef wmempcpy
#   define wmempcpy rpl_wmempcpy
#  endif
_GL_FUNCDECL_RPL (wmempcpy, wchar_t *,
                  (wchar_t *restrict dest,
                   const wchar_t *restrict src, size_t n));
_GL_CXXALIAS_RPL (wmempcpy, wchar_t *,
                  (wchar_t *restrict dest,
                   const wchar_t *restrict src, size_t n));
# else
#  if !1
_GL_FUNCDECL_SYS (wmempcpy, wchar_t *,
                  (wchar_t *restrict dest,
                   const wchar_t *restrict src, size_t n));
#  endif
_GL_CXXALIAS_SYS (wmempcpy, wchar_t *,
                  (wchar_t *restrict dest,
                   const wchar_t *restrict src, size_t n));
# endif
# if __GLIBC__ >= 2
_GL_CXXALIASWARN (wmempcpy);
# endif
#elif defined GNULIB_POSIXCHECK
# undef wmempcpy
# if HAVE_RAW_DECL_WMEMPCPY
_GL_WARN_ON_USE (wmempcpy, "wmempcpy is unportable - "
                 "use gnulib module wmempcpy for portability");
# endif
#endif


/* Set N wide characters of S to C.  */
#if 0
# if !1
_GL_FUNCDECL_SYS (wmemset, wchar_t *, (wchar_t *s, wchar_t c, size_t n));
# endif
_GL_CXXALIAS_SYS (wmemset, wchar_t *, (wchar_t *s, wchar_t c, size_t n));
# if __GLIBC__ >= 2
_GL_CXXALIASWARN (wmemset);
# endif
#elif defined GNULIB_POSIXCHECK
# undef wmemset
# if HAVE_RAW_DECL_WMEMSET
_GL_WARN_ON_USE (wmemset, "wmemset is unportable - "
                 "use gnulib module wmemset for portability");
# endif
#endif


/* Return the number of wide characters in S.  */
#if 0
# if !1
_GL_FUNCDECL_SYS (wcslen, size_t, (const wchar_t *s) _GL_ATTRIBUTE_PURE);
# endif
_GL_CXXALIAS_SYS (wcslen, size_t, (const wchar_t *s));
# if __GLIBC__ >= 2
_GL_CXXALIASWARN (wcslen);
# endif
#elif defined GNULIB_POSIXCHECK
# undef wcslen
# if HAVE_RAW_DECL_WCSLEN
_GL_WARN_ON_USE (wcslen, "wcslen is unportable - "
                 "use gnulib module wcslen for portability");
# endif
#endif


/* Return the number of wide characters in S, but at most MAXLEN.  */
#if 0
/* On Solaris 11.3, the header files declare the function in the std::
   namespace, not in the global namespace.  So, force a declaration in
   the global namespace.  */
# if !1 || (defined __sun && defined __cplusplus)
_GL_FUNCDECL_SYS (wcsnlen, size_t, (const wchar_t *s, size_t maxlen)
                                   _GL_ATTRIBUTE_PURE);
# endif
_GL_CXXALIAS_SYS (wcsnlen, size_t, (const wchar_t *s, size_t maxlen));
_GL_CXXALIASWARN (wcsnlen);
#elif defined GNULIB_POSIXCHECK
# undef wcsnlen
# if HAVE_RAW_DECL_WCSNLEN
_GL_WARN_ON_USE (wcsnlen, "wcsnlen is unportable - "
                 "use gnulib module wcsnlen for portability");
# endif
#endif


/* Copy SRC to DEST.  */
#if 0
# if !1
_GL_FUNCDECL_SYS (wcscpy, wchar_t *,
                  (wchar_t *restrict dest, const wchar_t *restrict src));
# endif
_GL_CXXALIAS_SYS (wcscpy, wchar_t *,
                  (wchar_t *restrict dest, const wchar_t *restrict src));
# if __GLIBC__ >= 2
_GL_CXXALIASWARN (wcscpy);
# endif
#elif defined GNULIB_POSIXCHECK
# undef wcscpy
# if HAVE_RAW_DECL_WCSCPY
_GL_WARN_ON_USE (wcscpy, "wcscpy is unportable - "
                 "use gnulib module wcscpy for portability");
# endif
#endif


/* Copy SRC to DEST, returning the address of the terminating L'\0' in DEST.  */
#if 0
/* On Solaris 11.3, the header files declare the function in the std::
   namespace, not in the global namespace.  So, force a declaration in
   the global namespace.  */
# if !1 || (defined __sun && defined __cplusplus)
_GL_FUNCDECL_SYS (wcpcpy, wchar_t *,
                  (wchar_t *restrict dest, const wchar_t *restrict src));
# endif
_GL_CXXALIAS_SYS (wcpcpy, wchar_t *,
                  (wchar_t *restrict dest, const wchar_t *restrict src));
_GL_CXXALIASWARN (wcpcpy);
#elif defined GNULIB_POSIXCHECK
# undef wcpcpy
# if HAVE_RAW_DECL_WCPCPY
_GL_WARN_ON_USE (wcpcpy, "wcpcpy is unportable - "
                 "use gnulib module wcpcpy for portability");
# endif
#endif


/* Copy no more than N wide characters of SRC to DEST.  */
#if 0
# if !1
_GL_FUNCDECL_SYS (wcsncpy, wchar_t *,
                  (wchar_t *restrict dest,
                   const wchar_t *restrict src, size_t n));
# endif
_GL_CXXALIAS_SYS (wcsncpy, wchar_t *,
                  (wchar_t *restrict dest,
                   const wchar_t *restrict src, size_t n));
# if __GLIBC__ >= 2
_GL_CXXALIASWARN (wcsncpy);
# endif
#elif defined GNULIB_POSIXCHECK
# undef wcsncpy
# if HAVE_RAW_DECL_WCSNCPY
_GL_WARN_ON_USE (wcsncpy, "wcsncpy is unportable - "
                 "use gnulib module wcsncpy for portability");
# endif
#endif


/* Copy no more than N characters of SRC to DEST, returning the address of
   the last character written into DEST.  */
#if 0
/* On Solaris 11.3, the header files declare the function in the std::
   namespace, not in the global namespace.  So, force a declaration in
   the global namespace.  */
# if !1 || (defined __sun && defined __cplusplus)
_GL_FUNCDECL_SYS (wcpncpy, wchar_t *,
                  (wchar_t *restrict dest,
                   const wchar_t *restrict src, size_t n));
# endif
_GL_CXXALIAS_SYS (wcpncpy, wchar_t *,
                  (wchar_t *restrict dest,
                   const wchar_t *restrict src, size_t n));
_GL_CXXALIASWARN (wcpncpy);
#elif defined GNULIB_POSIXCHECK
# undef wcpncpy
# if HAVE_RAW_DECL_WCPNCPY
_GL_WARN_ON_USE (wcpncpy, "wcpncpy is unportable - "
                 "use gnulib module wcpncpy for portability");
# endif
#endif


/* Append SRC onto DEST.  */
#if 0
# if !1
_GL_FUNCDECL_SYS (wcscat, wchar_t *,
                  (wchar_t *restrict dest, const wchar_t *restrict src));
# endif
_GL_CXXALIAS_SYS (wcscat, wchar_t *,
                  (wchar_t *restrict dest, const wchar_t *restrict src));
# if __GLIBC__ >= 2
_GL_CXXALIASWARN (wcscat);
# endif
#elif defined GNULIB_POSIXCHECK
# undef wcscat
# if HAVE_RAW_DECL_WCSCAT
_GL_WARN_ON_USE (wcscat, "wcscat is unportable - "
                 "use gnulib module wcscat for portability");
# endif
#endif


/* Append no more than N wide characters of SRC onto DEST.  */
#if 0
# if !1
_GL_FUNCDECL_SYS (wcsncat, wchar_t *,
                  (wchar_t *restrict dest, const wchar_t *restrict src,
                   size_t n));
# endif
_GL_CXXALIAS_SYS (wcsncat, wchar_t *,
                  (wchar_t *restrict dest, const wchar_t *restrict src,
                   size_t n));
# if __GLIBC__ >= 2
_GL_CXXALIASWARN (wcsncat);
# endif
#elif defined GNULIB_POSIXCHECK
# undef wcsncat
# if HAVE_RAW_DECL_WCSNCAT
_GL_WARN_ON_USE (wcsncat, "wcsncat is unportable - "
                 "use gnulib module wcsncat for portability");
# endif
#endif


/* Compare S1 and S2.  */
#if 0
# if 0
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef wcscmp
#   define wcscmp rpl_wcscmp
#  endif
_GL_FUNCDECL_RPL (wcscmp, int, (const wchar_t *s1, const wchar_t *s2)
                               _GL_ATTRIBUTE_PURE);
_GL_CXXALIAS_RPL (wcscmp, int, (const wchar_t *s1, const wchar_t *s2));
# else
#  if !1
_GL_FUNCDECL_SYS (wcscmp, int, (const wchar_t *s1, const wchar_t *s2)
                               _GL_ATTRIBUTE_PURE);
#  endif
_GL_CXXALIAS_SYS (wcscmp, int, (const wchar_t *s1, const wchar_t *s2));
# endif
# if __GLIBC__ >= 2
_GL_CXXALIASWARN (wcscmp);
# endif
#elif defined GNULIB_POSIXCHECK
# undef wcscmp
# if HAVE_RAW_DECL_WCSCMP
_GL_WARN_ON_USE (wcscmp, "wcscmp is unportable - "
                 "use gnulib module wcscmp for portability");
# endif
#endif


/* Compare no more than N wide characters of S1 and S2.  */
#if 0
# if 0
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef wcsncmp
#   define wcsncmp rpl_wcsncmp
#  endif
_GL_FUNCDECL_RPL (wcsncmp, int,
                  (const wchar_t *s1, const wchar_t *s2, size_t n)
                  _GL_ATTRIBUTE_PURE);
_GL_CXXALIAS_RPL (wcsncmp, int,
                  (const wchar_t *s1, const wchar_t *s2, size_t n));
# else
#  if !1
_GL_FUNCDECL_SYS (wcsncmp, int,
                  (const wchar_t *s1, const wchar_t *s2, size_t n)
                  _GL_ATTRIBUTE_PURE);
#  endif
_GL_CXXALIAS_SYS (wcsncmp, int,
                  (const wchar_t *s1, const wchar_t *s2, size_t n));
# endif
# if __GLIBC__ >= 2
_GL_CXXALIASWARN (wcsncmp);
# endif
#elif defined GNULIB_POSIXCHECK
# undef wcsncmp
# if HAVE_RAW_DECL_WCSNCMP
_GL_WARN_ON_USE (wcsncmp, "wcsncmp is unportable - "
                 "use gnulib module wcsncmp for portability");
# endif
#endif


/* Compare S1 and S2, ignoring case.  */
#if 0
/* On Solaris 11.3, the header files declare the function in the std::
   namespace, not in the global namespace.  So, force a declaration in
   the global namespace.  */
# if !1 || (defined __sun && defined __cplusplus)
_GL_FUNCDECL_SYS (wcscasecmp, int, (const wchar_t *s1, const wchar_t *s2)
                                   _GL_ATTRIBUTE_PURE);
# endif
_GL_CXXALIAS_SYS (wcscasecmp, int, (const wchar_t *s1, const wchar_t *s2));
_GL_CXXALIASWARN (wcscasecmp);
#elif defined GNULIB_POSIXCHECK
# undef wcscasecmp
# if HAVE_RAW_DECL_WCSCASECMP
_GL_WARN_ON_USE (wcscasecmp, "wcscasecmp is unportable - "
                 "use gnulib module wcscasecmp for portability");
# endif
#endif


/* Compare no more than N chars of S1 and S2, ignoring case.  */
#if 0
/* On Solaris 11.3, the header files declare the function in the std::
   namespace, not in the global namespace.  So, force a declaration in
   the global namespace.  */
# if !1 || (defined __sun && defined __cplusplus)
_GL_FUNCDECL_SYS (wcsncasecmp, int,
                  (const wchar_t *s1, const wchar_t *s2, size_t n)
                  _GL_ATTRIBUTE_PURE);
# endif
_GL_CXXALIAS_SYS (wcsncasecmp, int,
                  (const wchar_t *s1, const wchar_t *s2, size_t n));
_GL_CXXALIASWARN (wcsncasecmp);
#elif defined GNULIB_POSIXCHECK
# undef wcsncasecmp
# if HAVE_RAW_DECL_WCSNCASECMP
_GL_WARN_ON_USE (wcsncasecmp, "wcsncasecmp is unportable - "
                 "use gnulib module wcsncasecmp for portability");
# endif
#endif


/* Compare S1 and S2, both interpreted as appropriate to the LC_COLLATE
   category of the current locale.  */
#if 0
# if !1
_GL_FUNCDECL_SYS (wcscoll, int, (const wchar_t *s1, const wchar_t *s2));
# endif
_GL_CXXALIAS_SYS (wcscoll, int, (const wchar_t *s1, const wchar_t *s2));
# if __GLIBC__ >= 2
_GL_CXXALIASWARN (wcscoll);
# endif
#elif defined GNULIB_POSIXCHECK
# undef wcscoll
# if HAVE_RAW_DECL_WCSCOLL
_GL_WARN_ON_USE (wcscoll, "wcscoll is unportable - "
                 "use gnulib module wcscoll for portability");
# endif
#endif


/* Transform S2 into array pointed to by S1 such that if wcscmp is applied
   to two transformed strings the result is the as applying 'wcscoll' to the
   original strings.  */
#if 0
# if !1
_GL_FUNCDECL_SYS (wcsxfrm, size_t,
                  (wchar_t *restrict s1, const wchar_t *restrict s2, size_t n));
# endif
_GL_CXXALIAS_SYS (wcsxfrm, size_t,
                  (wchar_t *restrict s1, const wchar_t *restrict s2, size_t n));
# if __GLIBC__ >= 2
_GL_CXXALIASWARN (wcsxfrm);
# endif
#elif defined GNULIB_POSIXCHECK
# undef wcsxfrm
# if HAVE_RAW_DECL_WCSXFRM
_GL_WARN_ON_USE (wcsxfrm, "wcsxfrm is unportable - "
                 "use gnulib module wcsxfrm for portability");
# endif
#endif


/* Duplicate S, returning an identical malloc'd string.  */
#if 0
# if defined _WIN32 && !defined __CYGWIN__
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef wcsdup
#   define wcsdup _wcsdup
#  endif
_GL_CXXALIAS_MDA (wcsdup, wchar_t *, (const wchar_t *s));
# else
/* On Solaris 11.3, the header files declare the function in the std::
   namespace, not in the global namespace.  So, force a declaration in
   the global namespace.  */
#  if !1 || (defined __sun && defined __cplusplus) || __GNUC__ >= 11
#   if __GLIBC__ + (__GLIBC_MINOR__ >= 2) > 2
_GL_FUNCDECL_SYS (wcsdup, wchar_t *,
                  (const wchar_t *s)
                  _GL_ATTRIBUTE_NOTHROW
                  _GL_ATTRIBUTE_MALLOC _GL_ATTRIBUTE_DEALLOC_FREE);
#   else
_GL_FUNCDECL_SYS (wcsdup, wchar_t *,
                  (const wchar_t *s)
                  _GL_ATTRIBUTE_MALLOC _GL_ATTRIBUTE_DEALLOC_FREE);
#   endif
#  endif
_GL_CXXALIAS_SYS (wcsdup, wchar_t *, (const wchar_t *s));
# endif
_GL_CXXALIASWARN (wcsdup);
#else
# if __GNUC__ >= 11 && !defined wcsdup
/* For -Wmismatched-dealloc: Associate wcsdup with free or rpl_free.  */
#  if __GLIBC__ + (__GLIBC_MINOR__ >= 2) > 2
_GL_FUNCDECL_SYS (wcsdup, wchar_t *,
                  (const wchar_t *s)
                  _GL_ATTRIBUTE_NOTHROW
                  _GL_ATTRIBUTE_MALLOC _GL_ATTRIBUTE_DEALLOC_FREE);
#  else
_GL_FUNCDECL_SYS (wcsdup, wchar_t *,
                  (const wchar_t *s)
                  _GL_ATTRIBUTE_MALLOC _GL_ATTRIBUTE_DEALLOC_FREE);
#  endif
# endif
# if defined GNULIB_POSIXCHECK
#  undef wcsdup
#  if HAVE_RAW_DECL_WCSDUP
_GL_WARN_ON_USE (wcsdup, "wcsdup is unportable - "
                 "use gnulib module wcsdup for portability");
#  endif
# elif 1
/* On native Windows, map 'wcsdup' to '_wcsdup', so that -loldnames is not
   required.  In C++ with GNULIB_NAMESPACE, avoid differences between
   platforms by defining GNULIB_NAMESPACE::wcsdup always.  */
#  if defined _WIN32 && !defined __CYGWIN__
#   if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#    undef wcsdup
#    define wcsdup _wcsdup
#   endif
_GL_CXXALIAS_MDA (wcsdup, wchar_t *, (const wchar_t *s));
#  else
#   if __GLIBC__ + (__GLIBC_MINOR__ >= 2) > 2
_GL_FUNCDECL_SYS (wcsdup, wchar_t *,
                  (const wchar_t *s)
                  _GL_ATTRIBUTE_NOTHROW
                  _GL_ATTRIBUTE_MALLOC _GL_ATTRIBUTE_DEALLOC_FREE);
#   else
_GL_FUNCDECL_SYS (wcsdup, wchar_t *,
                  (const wchar_t *s)
                  _GL_ATTRIBUTE_MALLOC _GL_ATTRIBUTE_DEALLOC_FREE);
#   endif
#   if 1
_GL_CXXALIAS_SYS (wcsdup, wchar_t *, (const wchar_t *s));
#   endif
#  endif
#  if (defined _WIN32 && !defined __CYGWIN__) || 1
_GL_CXXALIASWARN (wcsdup);
#  endif
# endif
#endif


/* Find the first occurrence of WC in WCS.  */
#if 0
# if !1
_GL_FUNCDECL_SYS (wcschr, wchar_t *, (const wchar_t *wcs, wchar_t wc)
                                     _GL_ATTRIBUTE_PURE);
# endif
  /* On some systems, this function is defined as an overloaded function:
       extern "C++" {
         const wchar_t * std::wcschr (const wchar_t *, wchar_t);
         wchar_t * std::wcschr (wchar_t *, wchar_t);
       }  */
_GL_CXXALIAS_SYS_CAST2 (wcschr,
                        wchar_t *, (const wchar_t *, wchar_t),
                        const wchar_t *, (const wchar_t *, wchar_t));
# if ((__GLIBC__ == 2 && __GLIBC_MINOR__ >= 10) && !defined __UCLIBC__) \
     && (__GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 4))
_GL_CXXALIASWARN1 (wcschr, wchar_t *, (wchar_t *wcs, wchar_t wc));
_GL_CXXALIASWARN1 (wcschr, const wchar_t *, (const wchar_t *wcs, wchar_t wc));
# elif __GLIBC__ >= 2
_GL_CXXALIASWARN (wcschr);
# endif
#elif defined GNULIB_POSIXCHECK
# undef wcschr
# if HAVE_RAW_DECL_WCSCHR
_GL_WARN_ON_USE (wcschr, "wcschr is unportable - "
                 "use gnulib module wcschr for portability");
# endif
#endif


/* Find the last occurrence of WC in WCS.  */
#if 0
# if !1
_GL_FUNCDECL_SYS (wcsrchr, wchar_t *, (const wchar_t *wcs, wchar_t wc)
                                      _GL_ATTRIBUTE_PURE);
# endif
  /* On some systems, this function is defined as an overloaded function:
       extern "C++" {
         const wchar_t * std::wcsrchr (const wchar_t *, wchar_t);
         wchar_t * std::wcsrchr (wchar_t *, wchar_t);
       }  */
_GL_CXXALIAS_SYS_CAST2 (wcsrchr,
                        wchar_t *, (const wchar_t *, wchar_t),
                        const wchar_t *, (const wchar_t *, wchar_t));
# if ((__GLIBC__ == 2 && __GLIBC_MINOR__ >= 10) && !defined __UCLIBC__) \
     && (__GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 4))
_GL_CXXALIASWARN1 (wcsrchr, wchar_t *, (wchar_t *wcs, wchar_t wc));
_GL_CXXALIASWARN1 (wcsrchr, const wchar_t *, (const wchar_t *wcs, wchar_t wc));
# elif __GLIBC__ >= 2
_GL_CXXALIASWARN (wcsrchr);
# endif
#elif defined GNULIB_POSIXCHECK
# undef wcsrchr
# if HAVE_RAW_DECL_WCSRCHR
_GL_WARN_ON_USE (wcsrchr, "wcsrchr is unportable - "
                 "use gnulib module wcsrchr for portability");
# endif
#endif


/* Return the length of the initial segment of WCS which consists entirely
   of wide characters not in REJECT.  */
#if 0
# if !1
_GL_FUNCDECL_SYS (wcscspn, size_t, (const wchar_t *wcs, const wchar_t *reject)
                                   _GL_ATTRIBUTE_PURE);
# endif
_GL_CXXALIAS_SYS (wcscspn, size_t, (const wchar_t *wcs, const wchar_t *reject));
# if __GLIBC__ >= 2
_GL_CXXALIASWARN (wcscspn);
# endif
#elif defined GNULIB_POSIXCHECK
# undef wcscspn
# if HAVE_RAW_DECL_WCSCSPN
_GL_WARN_ON_USE (wcscspn, "wcscspn is unportable - "
                 "use gnulib module wcscspn for portability");
# endif
#endif


/* Return the length of the initial segment of WCS which consists entirely
   of wide characters in ACCEPT.  */
#if 0
# if !1
_GL_FUNCDECL_SYS (wcsspn, size_t, (const wchar_t *wcs, const wchar_t *accept)
                                  _GL_ATTRIBUTE_PURE);
# endif
_GL_CXXALIAS_SYS (wcsspn, size_t, (const wchar_t *wcs, const wchar_t *accept));
# if __GLIBC__ >= 2
_GL_CXXALIASWARN (wcsspn);
# endif
#elif defined GNULIB_POSIXCHECK
# undef wcsspn
# if HAVE_RAW_DECL_WCSSPN
_GL_WARN_ON_USE (wcsspn, "wcsspn is unportable - "
                 "use gnulib module wcsspn for portability");
# endif
#endif


/* Find the first occurrence in WCS of any character in ACCEPT.  */
#if 0
# if !1
_GL_FUNCDECL_SYS (wcspbrk, wchar_t *,
                  (const wchar_t *wcs, const wchar_t *accept)
                  _GL_ATTRIBUTE_PURE);
# endif
  /* On some systems, this function is defined as an overloaded function:
       extern "C++" {
         const wchar_t * std::wcspbrk (const wchar_t *, const wchar_t *);
         wchar_t * std::wcspbrk (wchar_t *, const wchar_t *);
       }  */
_GL_CXXALIAS_SYS_CAST2 (wcspbrk,
                        wchar_t *, (const wchar_t *, const wchar_t *),
                        const wchar_t *, (const wchar_t *, const wchar_t *));
# if ((__GLIBC__ == 2 && __GLIBC_MINOR__ >= 10) && !defined __UCLIBC__) \
     && (__GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 4))
_GL_CXXALIASWARN1 (wcspbrk, wchar_t *,
                   (wchar_t *wcs, const wchar_t *accept));
_GL_CXXALIASWARN1 (wcspbrk, const wchar_t *,
                   (const wchar_t *wcs, const wchar_t *accept));
# elif __GLIBC__ >= 2
_GL_CXXALIASWARN (wcspbrk);
# endif
#elif defined GNULIB_POSIXCHECK
# undef wcspbrk
# if HAVE_RAW_DECL_WCSPBRK
_GL_WARN_ON_USE (wcspbrk, "wcspbrk is unportable - "
                 "use gnulib module wcspbrk for portability");
# endif
#endif


/* Find the first occurrence of NEEDLE in HAYSTACK.  */
#if 0
# if 0
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef wcsstr
#   define wcsstr rpl_wcsstr
#  endif
_GL_FUNCDECL_RPL (wcsstr, wchar_t *,
                  (const wchar_t *restrict haystack,
                   const wchar_t *restrict needle)
                  _GL_ATTRIBUTE_PURE);
_GL_CXXALIAS_RPL (wcsstr, wchar_t *,
                  (const wchar_t *restrict haystack,
                   const wchar_t *restrict needle));
# else
#  if !1
_GL_FUNCDECL_SYS (wcsstr, wchar_t *,
                  (const wchar_t *restrict haystack,
                   const wchar_t *restrict needle)
                  _GL_ATTRIBUTE_PURE);
#  endif
  /* On some systems, this function is defined as an overloaded function:
       extern "C++" {
         const wchar_t * std::wcsstr (const wchar_t *, const wchar_t *);
         wchar_t * std::wcsstr (wchar_t *, const wchar_t *);
       }  */
_GL_CXXALIAS_SYS_CAST2 (wcsstr,
                        wchar_t *,
                        (const wchar_t *restrict, const wchar_t *restrict),
                        const wchar_t *,
                        (const wchar_t *restrict, const wchar_t *restrict));
# endif
# if ((__GLIBC__ == 2 && __GLIBC_MINOR__ >= 10) && !defined __UCLIBC__) \
     && (__GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 4))
_GL_CXXALIASWARN1 (wcsstr, wchar_t *,
                   (wchar_t *restrict haystack,
                    const wchar_t *restrict needle));
_GL_CXXALIASWARN1 (wcsstr, const wchar_t *,
                   (const wchar_t *restrict haystack,
                    const wchar_t *restrict needle));
# elif __GLIBC__ >= 2
_GL_CXXALIASWARN (wcsstr);
# endif
#elif defined GNULIB_POSIXCHECK
# undef wcsstr
# if HAVE_RAW_DECL_WCSSTR
_GL_WARN_ON_USE (wcsstr, "wcsstr is unportable - "
                 "use gnulib module wcsstr for portability");
# endif
#endif


/* Divide WCS into tokens separated by characters in DELIM.  */
#if 0
# if 0
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef wcstok
#   define wcstok rpl_wcstok
#  endif
_GL_FUNCDECL_RPL (wcstok, wchar_t *,
                  (wchar_t *restrict wcs, const wchar_t *restrict delim,
                   wchar_t **restrict ptr));
_GL_CXXALIAS_RPL (wcstok, wchar_t *,
                  (wchar_t *restrict wcs, const wchar_t *restrict delim,
                   wchar_t **restrict ptr));
# else
#  if !1
_GL_FUNCDECL_SYS (wcstok, wchar_t *,
                  (wchar_t *restrict wcs, const wchar_t *restrict delim,
                   wchar_t **restrict ptr));
#  endif
_GL_CXXALIAS_SYS (wcstok, wchar_t *,
                  (wchar_t *restrict wcs, const wchar_t *restrict delim,
                   wchar_t **restrict ptr));
# endif
# if __GLIBC__ >= 2
_GL_CXXALIASWARN (wcstok);
# endif
#elif defined GNULIB_POSIXCHECK
# undef wcstok
# if HAVE_RAW_DECL_WCSTOK
_GL_WARN_ON_USE (wcstok, "wcstok is unportable - "
                 "use gnulib module wcstok for portability");
# endif
#endif


/* Determine number of column positions required for first N wide
   characters (or fewer if S ends before this) in S.  */
#if 0
# if 0
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef wcswidth
#   define wcswidth rpl_wcswidth
#  endif
_GL_FUNCDECL_RPL (wcswidth, int, (const wchar_t *s, size_t n)
                                 _GL_ATTRIBUTE_PURE);
_GL_CXXALIAS_RPL (wcswidth, int, (const wchar_t *s, size_t n));
# else
#  if !1
_GL_FUNCDECL_SYS (wcswidth, int, (const wchar_t *s, size_t n)
                                 _GL_ATTRIBUTE_PURE);
#  endif
_GL_CXXALIAS_SYS (wcswidth, int, (const wchar_t *s, size_t n));
# endif
# if __GLIBC__ >= 2
_GL_CXXALIASWARN (wcswidth);
# endif
#elif defined GNULIB_POSIXCHECK
# undef wcswidth
# if HAVE_RAW_DECL_WCSWIDTH
_GL_WARN_ON_USE (wcswidth, "wcswidth is unportable - "
                 "use gnulib module wcswidth for portability");
# endif
#endif


/* Convert *TP to a date and time wide string.  See
   <https://pubs.opengroup.org/onlinepubs/9699919799/functions/wcsftime.html>.  */
#if 0
# if 0
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef wcsftime
#   define wcsftime rpl_wcsftime
#  endif
_GL_FUNCDECL_RPL (wcsftime, size_t,
                  (wchar_t *restrict __buf, size_t __bufsize,
                   const wchar_t *restrict __fmt,
                   const struct tm *restrict __tp)
                  _GL_ARG_NONNULL ((1, 3, 4)));
_GL_CXXALIAS_RPL (wcsftime, size_t,
                  (wchar_t *restrict __buf, size_t __bufsize,
                   const wchar_t *restrict __fmt,
                   const struct tm *restrict __tp));
# else
#  if !1
_GL_FUNCDECL_SYS (wcsftime, size_t,
                  (wchar_t *restrict __buf, size_t __bufsize,
                   const wchar_t *restrict __fmt,
                   const struct tm *restrict __tp)
                  _GL_ARG_NONNULL ((1, 3, 4)));
#  endif
_GL_CXXALIAS_SYS (wcsftime, size_t,
                  (wchar_t *restrict __buf, size_t __bufsize,
                   const wchar_t *restrict __fmt,
                   const struct tm *restrict __tp));
# endif
# if __GLIBC__ >= 2
_GL_CXXALIASWARN (wcsftime);
# endif
#elif defined GNULIB_POSIXCHECK
# undef wcsftime
# if HAVE_RAW_DECL_WCSFTIME
_GL_WARN_ON_USE (wcsftime, "wcsftime is unportable - "
                 "use gnulib module wcsftime for portability");
# endif
#endif


#if 0 && (defined _WIN32 && !defined __CYGWIN__)
/* Gets the name of the current working directory.
   (a) If BUF is non-NULL, it is assumed to have room for SIZE wide characters.
       This function stores the working directory (NUL-terminated) in BUF and
       returns BUF.
   (b) If BUF is NULL, an array is allocated with 'malloc'.  The array is SIZE
       wide characters long, unless SIZE == 0, in which case it is as big as
       necessary.
   If the directory couldn't be determined or SIZE was too small, this function
   returns NULL and sets errno.  For a directory of length LEN, SIZE should be
   >= LEN + 3 in case (a) or >= LEN + 1 in case (b).
   Possible errno values include:
     - ERANGE if SIZE is too small.
     - ENOMEM if the memory could no be allocated.  */
_GL_FUNCDECL_SYS (wgetcwd, wchar_t *, (wchar_t *buf, size_t size));
#endif


#endif /* _GL_WCHAR_H */
#endif /* _GL_WCHAR_H */
#endif
