#' 基于数据库，对ID向量进行转换，返回更新后的向量
#' NA值或空字符串会返回NA值
#'
#' @param old 要被转换的id向量，元素可以是多个id名的组合，用| ；或其它符号隔开。
#' @param db 注释数据库，包含旧名和新名
#' @param from 注释数据库中对应原来ID的列名
#' @param to 注释数据库中新ID的列名
#' @param split 如果ID向量为多id组合的，需要指定分割符号，默认为NULL，即为单个ID，无需分割
#' @param fixed 默认TRUE，strsplit函数的参数
#'
#' @return 转换后的向量
#' @export
#'
#' @examples
update_IDs <- function(old, db = ADataframe, from = NULL, to = NULL, split = NULL, fixed = TRUE){
  if (any(duplicated(db[,from]))) {
    warning("from列有重复值，仅保留第一个出现的ID。")
    db <- db[!duplicated(db[,from]),]
  }
  mapping <- db[,to]
  names(mapping) <- db[,from]

  res <- c()
  for (i in old) {
    if (is.null(split)) {
      res <- append(res, mapping[i])
    }else{
      if (is.na(i)) {
        res <- append(res, NA)
      }else{
        old.vector <- trimws(unlist(strsplit(i, split = split, fixed = fixed)))
        res <- append(res, paste0(mapping[old.vector], collapse = ";"))
      }
    }
  }
  return(res)
}



#' update the data.frame by multiple keywords
#' 依据数据库信息，和至多3种ID，更新数据。返回1个list，包含两个数据框，第一个matched：更新后的数据框，第二个lost，不能被识别的行。
#' 注意：该函数值更新了第一个关键词，即by.input列。另外，该函数在后两轮匹配时，会输出重复匹配的条目。
#'
#' @param inputDF 要被更新的数据框
#' @param db 数据库
#' @param by.input 数据框里的第一识别列（也是要被更新的列）
#' @param by.db 数据库里的第一识别列的对应列
#' @param by.input.2 数据框里的第二识别列，当第一识别列不能被识别时才启用（不会被更新），可以为NULL
#' @param by.db.2 数据库里的第二识别列的对应列，可以为NULL
#' @param by.input.3 数据框里的第三识别列，当第一和第二识别列均不能被识别时才启用（不会被更新），可以为NULL
#' @param by.db.3 数据库里的第三识别列的对应列，可以为NULL
#' @param label 默认为TRUE，添加label列，表征被第几个关键词所识别
#' @param verbose 是否输出被第二、三个关键词匹配的条目的详细信息，用于人工校验准确性。
#'
#' @return A list，包含两个数据框，第一个matched：更新后的数据框，第二个lost，不能被识别的行.可能的问题：1. 如果两个ensembl id对应同一个HGNC，那么第二轮
#' 用HGNC匹配时，可能仅能匹配到一个Ensebmbl id。同理第三轮匹配也是。
#' @export
#'
#' @examples
mapping_update <- function(inputDF, db = ADataframe, by.input = NULL, by.db = NULL, by.input.2 = NULL, by.db.2 = NULL,by.input.3 = NULL, by.db.3 = NULL, label = TRUE,
                           verbose = TRUE){
  message(paste0("1. 依据input里的",by.input,"列和数据库里的",by.db,"列进行数据比对:"))
  check_db <- function(db, column){ # 依据某一列，去除重复行。
    if(any(duplicated(db[,column]))){
      warning("数据库中的",column,"列发现有重复值，仅保留第一个出现的值。")
      return(db[!duplicated(db[,column]),])
    }else{
      return(db)
    }
  }
  ###### First match
  db.1 <- check_db(db, column = by.db)
  mapped <- inputDF[inputDF[,by.input] %in% db.1[,by.db],]
  if (nrow(mapped) == 0) { stop("0行可被匹配，请检查对应列的设置是否正确！") }
  if (label) { mapped$label = "First" } # 标记为被第一个关键词匹配上的
  lost <- inputDF[!inputDF[,by.input] %in% db.1[,by.db],]
  message(paste0(nrow(lost),"行未被对应上。"))
  if(nrow(lost) == 0 | is.null(by.input.2) | is.null(by.db.2)){ # 仅靠一列识别
    return(list(matched = mapped, lost = lost))
  }else{
    ############ Second match
    message(paste0("2. 依据input里的",by.input.2,"列和数据库里的",by.db.2,"列对未匹配的数据再次进行比对:"))
    db.2 <- check_db(db, column = by.db.2)
    lost.mapped <- lost[lost[,by.input.2] %in% db.2[,by.db.2],]
    if (nrow(lost.mapped) != 0) {
      if(label){lost.mapped$label = "Second" }  # 标记为被第二个关键词匹配上的
      if(verbose){message("请手动检查以下替换是否正确！")}
      if(verbose){message("替换前：")}
      if(verbose){print(lost.mapped[,c(by.input, by.input.2, by.input.3)])}
      lost.mapped[,by.input] <- db.2[,by.db][match(lost.mapped[,by.input.2], db.2[,by.db.2])] #修改第一个关键词
      if(verbose){message("替换后：")}
      if(verbose){print(lost.mapped[,c(by.input, by.input.2, by.input.3)])}
      if(any(lost.mapped[,by.input] %in% mapped[,by.input])){
        message("注意：以下条目与第一次匹配到的条目有重复。")
        print(lost.mapped[lost.mapped[,by.input] %in% mapped[,by.input],c(by.input, by.input.2, by.input.3)])
      }
    }
    lost.lost <- lost[!lost[,by.input.2] %in% db.2[,by.db.2],]
    message(paste0(nrow(lost.lost),"行未被对应上。"))
    if (nrow(lost.lost) == 0 | is.null(by.input.3) | is.null(by.db.3)) { # 仅靠两列识别
      if(nrow(lost.mapped) != 0){return(list(matched = rbind(mapped, lost.mapped), lost = lost.lost))
      }else{return(list(matched = mapped, lost = lost.lost))}
    }else{
      ########### Third match
      message(paste0("3. 依据input里的",by.input.3,"列和数据库里的",by.db.3,"列对未匹配的数据再次进行比对:"))
      db.3 <- check_db(db, column = by.db.3)
      lost.lost.mapped <- lost.lost[lost.lost[,by.input.3] %in% db.3[,by.db.3],]
      if (nrow(lost.lost.mapped) != 0) {
        if(label) { lost.lost.mapped$label = "Third" }   # 标记为被第三个关键词匹配上的
        if(verbose){message("请手动检查以下替换是否正确！")}
        if(verbose){message("替换前：")}
        if(verbose){print(lost.lost.mapped[,c(by.input, by.input.2, by.input.3)])}
        lost.lost.mapped[,by.input] <- db.3[,by.db][match(lost.lost.mapped[,by.input.3], db.3[,by.db.3])] # 修改第一个关键词
        # lost.lost.mapped[,by.input.2] <- db.3[,by.db.2][match(lost.lost.mapped[,by.input.3], db.3[,by.db.3])] # 修改第二个关键词
        if(verbose){message("替换后：")}
        if(verbose){print(lost.lost.mapped[,c(by.input, by.input.2, by.input.3)])}
        if(any(lost.lost.mapped[,by.input] %in% mapped[,by.input])){
          message("注意：以下条目与第一次匹配到的条目有重复。")
          print(lost.lost.mapped[lost.lost.mapped[,by.input] %in% mapped[,by.input],c(by.input, by.input.2, by.input.3)])
        }
        if(any(lost.lost.mapped[,by.input] %in% lost.mapped[,by.input])){
          message("注意：以下条目与第二次匹配到的条目有重复。")
          print(lost.lost.mapped[lost.lost.mapped[,by.input] %in% lost.mapped[,by.input],c(by.input, by.input.2, by.input.3)])
        }
      }
      lost.lost.lost <- lost.lost[!lost.lost[,by.input.3] %in% db.3[,by.db.3],]
      message(paste0(nrow(lost.lost.lost),"行未被对应上。"))
      matched = list(mapped, lost.mapped, lost.lost.mapped)
      matched <- matched[c(TRUE, nrow(lost.mapped) > 0, nrow(lost.lost.mapped) > 0)]
      matched <- Reduce(rbind, matched)
      return(list(matched = matched, lost = lost.lost.lost))
    }
  }
}
