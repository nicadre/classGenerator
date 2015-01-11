#!/usr/bin/env ruby
# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    classGenerator.rb                                  :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: niccheva <niccheva@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2015/01/10 23:06:54 by niccheva          #+#    #+#              #
#    Updated: 2015/01/11 09:56:31 by niccheva         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

def constructorComment(f)
  f.write "/* "
  30.times do
    f.write "*"
  end
  f.write " Constructors "
  30.times do
    f.write "*"
  end
  f.write " */\n"
end

def destructorComment(f)
  f.write "/* "
  30.times do
    f.write "*"
  end
  f.write " Destructors "
  31.times do
    f.write "*"
  end
  f.write " */\n"
end

def operatorComment(f)
  f.write "/* "
  27.times do
    f.write "*"
  end
  f.write " Operator Overload "
  28.times do
    f.write "*"
  end
  f.write " */\n"
end

def getPrivate(args)
  i = 0;
  ary = Array.new
  while (i < args.length && args[i] != "-private") do
    i += 1
  end
  return nil unless i < args.length
  i += 1
  until i >= args.length || args[i] == "-protected" || args[i] == "-public" do
    ary << [args[i], args[i + 1]]
    i += 2
  end
  ary
end

def getProtected(args)
  i = 0;
  ary = Array.new
  while (i < args.length && args[i] != "-protected") do
    i += 1
  end

  return nil unless i < args.length
  i += 1

  until i >= args.length || args[i] == "-private" || args[i] == "-public" do
    ary << [args[i], args[i + 1]]
    i += 2
  end
  ary
end

def getPublic(args)
  i = 0;
  ary = Array.new
  while (i < args.length && args[i] != "-public") do
    i += 1
  end

  return nil unless i < args.length
  i += 1

  until i >= args.length || args[i] == "-protected" || args[i] == "-private" do
    ary << [args[i], args[i + 1]]
    i += 2
  end
  ary
end

if ARGV.length == 0
  puts "Please read README file for usage"
  exit
end

name = ARGV[0]

if File.exist?(name + ".class.hpp")
  puts "Hpp file exist, please remove it"
  exit
end

File.open(name + ".class.hpp", 'w') do |f|
  f.write "\n#ifndef\t\t#{name.upcase}_CLASS_HPP\n"
  f.write "# define\t#{name.upcase}_CLASS_HPP\n\n"

  f.write "class #{name} {\n"
  #  f.write "private:\n"
  #  f.write "\ttest;\n\n"

  privates = getPrivate ARGV
  protecteds = getProtected ARGV
  publics = getPublic ARGV

  puts privates
  puts protecteds
  puts publics

  f.write "public:\n"
  if publics
    publics.each do |hash|
      f.write "\t#{hash[0]}\t\t\t#{hash[1]};\n"
    end
  end

  constructorComment f
  f.write "\t#{name}(void);\n"
  f.write "\t#{name}(#{name} const & src);\n\n"

  destructorComment f
  f.write "\t~#{name}(void);\n\n"

  operatorComment f
  f.write "\t#{name} const\t\t\t&operator=(#{name} const & rhs);\n\n"

  f.write "private:\n" if privates

  f.write "protected:\n" if protecteds

  f.write "};\n\n"
  f.write "#endif //\t#{name.upcase}_CLASS_HPP\n"
end

if File.exist?(name + ".class.cpp")
  puts "Cpp file exist, please remove it"
  exit
end

File.open(name + ".class.cpp", 'w') do |f|
  f.write "\n#include \"#{name}.class.hpp\"\n\n"

  constructorComment f
  f.write "\n#{name}::#{name}(void) {\n\n}\n\n"
  f.write "#{name}::#{name}(#{name} const & src) {\n\t*this = src;\n}\n\n"

  destructorComment f
  f.write "\n#{name}::~#{name}(void) {\n\n}\n\n"

  operatorComment f
  f.write "\n#{name} const\t\t\t&#{name}::operator=(#{name} const & rhs) {\n\nr\treturn (*this);\n}\n"

end