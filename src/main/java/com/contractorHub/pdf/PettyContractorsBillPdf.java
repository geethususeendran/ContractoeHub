package com.contractorHub.pdf;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.math.BigDecimal;



import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Chunk;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.ExceptionConverter;
import com.itextpdf.text.Font;
import com.itextpdf.text.Font.FontFamily;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfName;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class PettyContractorsBillPdf {
	public static ByteArrayInputStream pdfReport(HttpServletRequest
			request, HttpServletResponse response,
			String regNo, String contractorPrefix, String serialNo, String serviceCode, String iomDate,String DateOfIssue,String address,String locationOfWork,String descriptionOfWork,
			String dateUndertaken,String entryPassNo,String department,double billamount,String formattedBillAmount,String conName,String billAmountWords,
			BigDecimal roundedCgst,BigDecimal roundedSgst,BigDecimal total) throws  IOException{
		String path = request.getServletContext().getRealPath("");

		// path=path.substring(1);
		System.out.println("path=======" + path);
		@SuppressWarnings("unused")
		HttpSession session = request.getSession();

		
		response.setContentType("application/pdf");
	

		String arial = request.getServletContext().getRealPath("/font/ARIAL.TTF");
		String arialBold = request.getServletContext().getRealPath("/font/ARIALBD.TTF");
		// BaseFont base = BaseFont.createFont(arial, BaseFont.WINANSI,false);

		Font malfont = FontFactory.getFont(request.getServletContext().getRealPath("/font/arial-unicode-ms.ttf"),
				BaseFont.IDENTITY_H, BaseFont.EMBEDDED, 10f, Font.BOLD, BaseColor.BLACK);

        //	Font malfont = FontFactory.getFont(request.getServletContext().getRealPath("/font/arial-unicode-ms.ttf"));

		Font font = FontFactory.getFont(request.getServletContext().getRealPath("/font/ARIAL.TTF"), BaseFont.IDENTITY_H,
				BaseFont.EMBEDDED, 5f, Font.BOLD, BaseColor.BLACK);
		// Font font = new Font(base, 5f, Font.BOLD);
        font.setColor(BaseColor.BLACK);
        Font fontBold = FontFactory.getFont(request.getServletContext().getRealPath("/font/ARIAL.TTF"),
                BaseFont.IDENTITY_H, BaseFont.EMBEDDED, 6f, Font.BOLD, BaseColor.BLACK);

        Font fontTitle = FontFactory.getFont(request.getServletContext().getRealPath("/font/ARIAL.TTF"),
                BaseFont.IDENTITY_H, BaseFont.EMBEDDED, 5f, Font.BOLD, BaseColor.BLACK);
        // Font font = new Font(base, 5f, Font.BOLD);
        font.setColor(BaseColor.BLACK);

        Font heading1 = new Font(FontFamily.TIMES_ROMAN, 12.0f, Font.BOLD, BaseColor.BLACK);
        Font titleFont = new Font(FontFamily.TIMES_ROMAN, 14.0f, Font.BOLD, BaseColor.BLACK);
        Font fontBody = new Font(FontFamily.TIMES_ROMAN, 13.0f, Font.NORMAL, BaseColor.BLACK);
        Font fontBoldBody = new Font(FontFamily.TIMES_ROMAN, 10.0f, Font.BOLD, BaseColor.BLACK);
        Font fontSmallBody = new Font(FontFamily.TIMES_ROMAN, 8.0f, Font.NORMAL, BaseColor.BLACK);
        Paragraph h1 = new Paragraph();
        Chunk chunk = new Chunk("");

        ByteArrayOutputStream out = new ByteArrayOutputStream();
		Document document = new Document();
		try {

			/* Basic PDF Creation inside servlet */

			document.setPageSize(PageSize.A4);
			document.setMargins(60, 50, 0, 0);
			PdfWriter writer = PdfWriter.getInstance(document, out);
			document.open();
			Paragraph p1 = new Paragraph("  ");
			p1.setSpacingAfter(5);
			document.add(p1);
			
			p1 = new Paragraph("  ");
			document.add(p1);

            PdfPTable headerTable = new PdfPTable(3);
            headerTable.setWidths(new float[] { 2f, 4f, 2f });
            headerTable.setWidthPercentage(100);
            headerTable.getDefaultCell().setBorder(Rectangle.NO_BORDER);

            String regDisplay = regNo != null && !regNo.isEmpty() ? regNo : "";
            PdfPCell leftCell = new PdfPCell(new Phrase("Reg No. " + regDisplay, heading1));
            leftCell.setBorder(Rectangle.NO_BORDER);
            leftCell.setHorizontalAlignment(Element.ALIGN_LEFT);

            PdfPCell centerCell = new PdfPCell(new Phrase("PETTY CONTRACTOR'S BILL", titleFont));
            centerCell.setBorder(Rectangle.NO_BORDER);
            centerCell.setHorizontalAlignment(Element.ALIGN_CENTER);

            PdfPCell rightCell = new PdfPCell(new Phrase("Date of Issue : " + DateOfIssue, fontBody));
            rightCell.setBorder(Rectangle.NO_BORDER);
            rightCell.setHorizontalAlignment(Element.ALIGN_RIGHT);

            headerTable.addCell(leftCell);
            headerTable.addCell(centerCell);
            headerTable.addCell(rightCell);
            headerTable.setSpacingAfter(15);
            document.add(headerTable);

            String formattedSerial = serialNo != null ? serialNo.trim() : "";
            if (contractorPrefix != null && !contractorPrefix.isEmpty() && formattedSerial != null && !formattedSerial.startsWith(contractorPrefix)) {
                formattedSerial = contractorPrefix + formattedSerial;
            }

            h1 = new Paragraph();
            chunk = new Chunk("Serial No : " + formattedSerial, fontBody);
            h1.setAlignment(Element.ALIGN_LEFT);
            h1.setFont(fontBody);
            h1.add(chunk);
            h1.setSpacingAfter(8);
            document.add(h1);

            String renderedServiceCode = serviceCode != null ? serviceCode.trim() : "";
            if (!renderedServiceCode.isEmpty()) {
                h1 = new Paragraph();
                chunk = new Chunk("Service Code : " + renderedServiceCode, fontBody);
                h1.setAlignment(Element.ALIGN_LEFT);
                h1.setFont(fontBody);
                h1.add(chunk);
                h1.setSpacingAfter(10);
                document.add(h1);
            }

            h1 = new Paragraph();
            h1.setSpacingAfter(10);
            document.add(h1);

            float [] pointColumnWidths01 = {180F,160F};
            PdfPTable pdfPTable01 = new PdfPTable(2);

            pdfPTable01.setWidths(pointColumnWidths01);
            pdfPTable01.setSpacingBefore(8);
            pdfPTable01.setSpacingAfter(5);
            pdfPTable01.setWidthPercentage(100);
            
            PdfPCell pdfPCell02 = new PdfPCell(new Paragraph("3.Name, Address and GSTIN of the supplier :    ", fontBody));
            PdfPCell pdfPCell01 = new PdfPCell(new Paragraph(conName + "                                        "
                    + address, fontBoldBody));

            pdfPCell01.setMinimumHeight(10f);
            pdfPCell01.setBorder(Rectangle.NO_BORDER);
            pdfPCell02.setBorder(Rectangle.NO_BORDER);
            pdfPTable01.addCell(pdfPCell02);
            pdfPTable01.addCell(pdfPCell01);
            document.add(pdfPTable01);
			 float [] pointColumnWidths02 = {180F,160F};
			 PdfPTable pdfPTable02 = new PdfPTable(2);
		  
			 	 pdfPTable02.setWidths(pointColumnWidths02);
				 pdfPTable02.setSpacingAfter(10);
				 pdfPTable02.setWidthPercentage(100);
				 
				 PdfPCell pdfPCell03 = new PdfPCell(new Paragraph("4.Name, Address and GSTIN or UIN  "
				 		+ "                                   If registered of the required :    ", fontBody));
				 PdfPCell pdfPCell04 = new PdfPCell(new Paragraph("TRAVANCORE TITANIUM PRODUCTS LTD                              "
				 	+ " GSTIN:32AAACT85433J1ZQ", fontBoldBody));
				
				 pdfPCell03.setMinimumHeight(10f);
				 pdfPCell03.setBorder(Rectangle.NO_BORDER);
				 pdfPCell04.setBorder(Rectangle.NO_BORDER);
				 pdfPTable02.addCell(pdfPCell03);
				 pdfPTable02.addCell(pdfPCell04);
				 document.add(pdfPTable02);
				

				h1 = new Paragraph();
				Chunk chunk3 = new Chunk("5.IOM Date :                                          			                              " +iomDate, fontBody);
				chunk3.setFont(fontBody);
				h1.setAlignment(Element.ALIGN_LEFT);
				h1.setFont(fontBody);
				h1.add(chunk3);
				h1.setSpacingAfter(10);
				document.add(h1);

				h1 = new Paragraph();
				Chunk chunk4 = new Chunk("6.Location of Work :                                                            "+locationOfWork, fontBody);
				h1.setAlignment(Element.ALIGN_LEFT);
				h1.setFont(fontBody);
				h1.add(chunk4);
				h1.setSpacingAfter(10);
				document.add(h1);
					
				h1 = new Paragraph();
				Chunk chunk5 = new Chunk("7.Description of Work   :                                                      "+descriptionOfWork , fontBody);
				h1.setAlignment(Element.ALIGN_LEFT);
				h1.setFont(fontBody);
				h1.add(chunk5);
				h1.setSpacingAfter(10);
				document.add(h1);
					
				h1 = new Paragraph();
				Chunk chunk6 = new Chunk("8.Date on which the work was undertake   :                        " +dateUndertaken, fontBody);		
				h1.setAlignment(Element.ALIGN_LEFT);
				h1.setFont(fontBody);
				h1.add(chunk6);
				h1.setSpacingAfter(10);
				document.add(h1);
					
				h1 = new Paragraph();
				Chunk chunk7 = new Chunk("9.Entry Pass No. :                                                                 "+entryPassNo, fontBody);			
				h1.setAlignment(Element.ALIGN_LEFT);
				h1.setFont(fontBody);
				h1.add(chunk7);
				h1.setSpacingAfter(10);
				document.add(h1);
					
				h1 = new Paragraph();
				Chunk chunk8 = new Chunk("10.Department and Section from wich the work was arranged  :    " +department, fontBody);
				h1.setAlignment(Element.ALIGN_LEFT);
				h1.setFont(fontBody);
				h1.add(chunk8);
				h1.setSpacingAfter(10);
				document.add(h1);
			

			
			   String content = "I have undertake the above contract in Travancore Titanium Products Ltd have completed the work in time as instructed by the Office in charge, as I request that the bill amount of Rs.   "+billamount+ "/- .......................\n" +
                    "(Rupees  "+billAmountWords +" only ) may be sanctioned to me\n" +
                    "                                                                                                                      \n" +
                    "Total value of supply of service                                         =  "+formattedBillAmount +           " \n" +
                    "Rate of Tax                                     CGST: 9%                   =   "+roundedCgst +"                 \n"+
                    "                                                        SGST: 9%                   =   "+roundedSgst+"                  \n"+
                    "Total Amount                                                                      = "+total+"                  \n"+
                    "                                                                                                                      \n" +
                    "Rupees   "+billAmountWords +"   only                                                          "                                                                                                                              ;
            Paragraph paragraph = new Paragraph(content, fontBody);
            paragraph.setSpacingAfter(2);
            document.add(paragraph);
            
            h1=new Paragraph();
			chunk=new Chunk("Signature of Contractor",fontBody);
			chunk.setFont(fontBoldBody);
			h1.setAlignment(Element.ALIGN_RIGHT);
			h1.setFont(fontBody);
			h1.add(chunk);		
			h1.setSpacingAfter(5);
			document.add(h1);
			
			
			 String content1 = "................................................................................................................................................................................\n" +
             "Verified that...................................................Person Under contractor       "            
					 
             +conName+   "\n" +
             "Entered as per No(s):  "+entryPassNo+    "                                           Date : "+iomDate+ "\n" ;
                                                                                                
            Paragraph paragraph5 = new Paragraph(content1, fontBody);
            paragraph5.setSpacingAfter(15);
            document.add(paragraph5);
            
            
            h1=new Paragraph();
			chunk=new Chunk("Security Officer",fontBody);
			chunk.setFont(fontBoldBody);
			h1.setAlignment(Element.ALIGN_RIGHT);
			h1.setFont(fontBody);
			h1.add(chunk);
			h1.setSpacingAfter(5);
			document.add(h1);
			
			 
            h1=new Paragraph();
			chunk=new Chunk("Recommendation from Department",fontBody);
			chunk.setFont(fontBoldBody);
			h1.setAlignment(Element.ALIGN_LEFT);
			h1.setFont(fontBody);
			h1.add(chunk);
			h1.setSpacingAfter(50);
			document.add(h1);
			
			 h1=new Paragraph();
			 chunk=new Chunk("Officer in Charge",fontBody);
			 chunk.setFont(fontBoldBody);
			 h1.setAlignment(Element.ALIGN_RIGHT);
			 h1.setFont(fontBody);
			 h1.add(chunk);
			 document.add(h1);
            
		
			document.close();

		} catch (DocumentException exc) {
			throw new IOException(exc.getMessage());
		} finally {
			// out.close();
		}
		return new ByteArrayInputStream(out.toByteArray());
	}

	@SuppressWarnings("unused")
	private static void absText(String text, int x, int y, PdfWriter writer, String arial) {
		try {
			PdfContentByte cb = writer.getDirectContent();
			BaseFont base = BaseFont.createFont(arial, BaseFont.IDENTITY_H, false);
			cb.saveState();
			cb.beginText();
			cb.moveText(x, y);
			cb.setFontAndSize(base, 6);
			cb.showText(text);
			cb.endText();
			cb.restoreState();
		} catch (DocumentException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	private void addFooterImproved(PdfWriter writer) {
		PdfPTable footer = new PdfPTable(2);
		try {
			// set defaults
			footer.setWidths(new int[] { 2, 20 });
			footer.setWidthPercentage(50);

			footer.setTotalWidth(527);
			footer.setLockedWidth(true);
			footer.getDefaultCell().setFixedHeight(30);
			footer.getDefaultCell().setBorder(Rectangle.TOP);
			footer.getDefaultCell().setBorderColor(BaseColor.RED);
			footer.getDefaultCell().setHorizontalAlignment(Element.ALIGN_RIGHT);
			footer.addCell(new Phrase(String.format("Page %d of", writer.getPageNumber()),
					new Font(Font.FontFamily.HELVETICA, 8)));

			// add placeholder for total page count
			PdfPCell totalPageCount = new PdfPCell();
			totalPageCount.setBorder(Rectangle.TOP);
			totalPageCount.setBorderColor(BaseColor.GREEN);
			footer.getDefaultCell().setHorizontalAlignment(Element.ALIGN_LEFT);
			footer.addCell(totalPageCount);

			// write page
			PdfContentByte canvas = writer.getDirectContent();
			canvas.beginMarkedContentSequence(PdfName.ARTIFACT);
			footer.writeSelectedRows(0, -1, 34, 20, canvas);
			canvas.endMarkedContentSequence();
		} catch (DocumentException de) {
			throw new ExceptionConverter(de);
		}
	
	}
}

