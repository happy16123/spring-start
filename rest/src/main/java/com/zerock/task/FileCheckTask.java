package com.zerock.task;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.zerock.domain.BoardAttachVO;
import com.zerock.mapper.BoardAttachMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Component
public class FileCheckTask {
	
	@Setter(onMethod_ = {@Autowired})
	private BoardAttachMapper attachMapper;
	
	private String getFolderYesterDay() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DATE, -2);
		String str = sdf.format(cal.getTime());
		
		return str.replace("-", File.separator);
	}

	@Scheduled(cron = "0 * * 10 * *")
	public void checkFiles() throws Exception{
		log.warn("File Check Task run ..............");
		log.warn(new Date());
		
		List<BoardAttachVO> fileList = attachMapper.getOldFiles();
		
		List<Path> fileListPaths = fileList.stream()
				.map(vo -> Paths.get("C:\\Users\\gustn\\Desktop\\spring-start\\upload", vo.getUploadPath(), vo.getUuid() + "_" + vo.getFileName()))
				.collect(Collectors.toList());
		
		fileList.stream().filter(vo -> vo.isFileType() == true)
			.map(vo -> Paths.get("C:\\Users\\gustn\\Desktop\\spring-start\\upload", vo.getUploadPath(), "_s" + vo.getUuid() + vo.getUuid() + "_" + vo.getFileName()))
			.forEach(p -> fileListPaths.add(p));
		
		log.warn("==========================");
		
		fileListPaths.forEach(p -> log.warn(p));
		
		File targetDir = Paths.get("C:\\Users\\gustn\\Desktop\\spring-start\\upload", getFolderYesterDay()).toFile();
		
		File[] removeFiles = targetDir.listFiles(file -> fileListPaths.contains(file.toPath()) == false);
		
		for(File file : removeFiles) {
			log.warn(file.getAbsolutePath());
			file.delete();
		}
	}
}
