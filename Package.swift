// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "YYModel",
    platforms: [
        .iOS(.v11),
        .macOS(.v10_13),
        .tvOS(.v11),
        .watchOS(.v4)
    ],
    products: [
        .library(name: "YYModel", targets: ["YYModel"]),
        .library(name: "YYModelDynamic", type: .dynamic, targets: ["YYModel"])
    ],
    targets: [
        // 1.目录直接存放的源代码与资源文件 - 适用于源码和资源较少的项目类型。
        // 目录结构示例：
        // - path
        //      - 源代码文件.{h,m,swift,...}
        //      - 资源文件.{png,xcprivacy,...}
        .target(
            name: "YYModel",
            path: "YYModel",
            exclude: [],
            resources: [
                .process("PrivacyInfo.xcprivacy"),
            ],
            publicHeadersPath: ".", //Tip: where “.” is a specific value relative to path
            cSettings: [
                .headerSearchPath("."), //Tip: where “.” is a specific value relative to path
                //.define("GTMBase64_MODULE"),
            ]
        ),
        
        
        
//        // 2.源代码与资源文件分别存放在path的不同子目录中 - 适用于源码与资源较多，并且源码进行分类的项目
//        // 目录结构示例：
//        // - path
//        //      - Sources
//        //          - 源代码文件.{h,m,swift,...}
//        //      - Resources
//        //          - 资源文件.{png,xcprivacy,...}
//        .target(
//            name: "GTMBase64",
//            path: "GTMBase64",
//            exclude: [],
//            sources: ["Sources"],
//            resources: [
//                .process("Resources/PrivacyInfo.xcprivacy"),
//            ],
//            publicHeadersPath: ".", //Tip: where “.” is a specific value relative to path
//            cSettings: [
//                .headerSearchPath("."), //Tip: where “.” is a specific value relative to path
//                //.define("GTMBase64_MODULE"),
//            ]
//        ),
        
        
        
    ]
)










/**
 OC To Package.swift 示例地址：
 1. SDWebImage通过添加include目录头文件的方式来实现管理OC框架
    https://github.com/SDWebImage/SDWebImage/blob/master/Package.swift
 
 2. AFNetworking通过添加Framework目录并添加module.modulemap文件来实现管理OC框架
    https://github.com/AFNetworking/AFNetworking/blob/master/Package.swift
 
 3. 最佳的文档解决方案是：直接查看PackageDescription类的相关解释。
 
 注意：
    1. 使用Swift 5.3+的版本配置正确后，可以不使用“module.modulemap + header.h”的方式，
 即可正确对Objective-C框架添加Swift Package Manager支持；并且在项目中同时支持在swift,oc文件中引入框架。
 
    2. 关于同时构建静态库和动态库注意事项。以GTMBase64和GTMBase64Dynamic为例：
        1. SPM导入框架时只导入其中一种即可。
        2. 在使用时库时，无论导入的静态库还是动态库，都使用"import GTMBase64"导入模块，其中“GTMBase64”是这个库的名称(即SPM对应的package name)
        3. 使用时注意动态库与静态库的区别
 
 
 Target注解：
 - path: 项目目标的根路径，如果为nil，SPM会在预定义的搜索路径和与目标同名的子目录中查找目标的源文件。
    - `Sources`, `Source`, `src`, and `srcs` for regular targets
    - `Tests`, `Sources`, `Source`, `src`, and `srcs` for test targets
    - 注意：不能逃出包的根目录，例如：`../Foo` or `/Foo` 这类型的路径无效，只能访问path内部目录，并且所有资源都是相对于path进行访问的。
 - exclude: 排除的路径是相对于目标路径而言的。该属性优先于 `sources` 和 `resources` 属性。
 - sources: 源文件所在的目录，如果值为‘nil’，SPM会将所有包含有效源文件的目录包含到目录路径中。
    - 路径可以是目录或者单个源文件的路径，它们也可以同时包含，SPM会递归搜索路径中的有效源文件。
 - resources: 加载资源文件
    - 资源文件可以放在Source源文件所在的目录，也可以将资源放在与Source同级的目录，如：“Resources”
 - publicHeadersPath: 包含C族目标公共标头的目录路径。路径是相对于path的值设置的。
    - 如果值为‘nil’,那么这个默认目录为path下的‘include’
    - 也可以设置设置指定路劲，例如：‘.’表示当前path的目录，设置”XXXDir“目录，则实际位于”path/XXXDir“
 - cSettings: C相关的项目配置，例如header搜索路径，宏定义；
    - .headerSearchPath("path/relative/to/my/target"),
    - .define("DISABLE_SOMETHING", .when(platforms: [.iOS], configuration: .release)),
 - swiftSettings: Swift编译的相关配置，例如：
    - .define("ENABLE_SOMETHING", .when(configuration: .release)),
 - linkerSettings: 链接设置，例如：
    - .linkLibrary("openssl", .when(platforms: [.linux])),

 
 Target的常用结构：
 类型一：源代码直接存放在path目录下。
 - 这种情况下path目录下不能再创建任何子目录，并且所有资源也应该都放在path目录下，适用于结构简单，资源少的情况。
 - 常用配置示例:
    - target(name: "GTMBase64",
             path: "GTMBase64",
             exclude: [],
             resources:[.process("PrivacyInfo.xcprivacy")],
             publicHeadersPath: ".", // "."相当于当前path目录
             cSettings: [.headerSearchPath(".")]
     )
 
 
 
 类型二: 源代码是存放在path目录下的子目录下，例如：Sources，与Taget同名的目录下。
 - 这种结构源代码一般存放在”Sources“，”与Taget同名目录“下，资源文件一般存放在”Resources“目录下，测试文件一般放在”Tests“下;
 - 注意: 这种情况下也可以把资源放在Path主目录下。
 - 常用配置示例：
     - target(name: "GTMBase64",
              path: "GTMBase64",
              exclude: [],
              sources: ["Source","Sources","App",...],
              resources:[.process("Resources/PrivacyInfo.xcprivacy")],
              publicHeadersPath: "include", // 默认”include“或者自定义的C类型头文件目录
              cSettings: [.headerSearchPath("Source"),...]
      )
 */
