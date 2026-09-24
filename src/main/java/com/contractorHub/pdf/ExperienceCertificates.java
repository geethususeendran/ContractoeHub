package com.contractorHub.pdf;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import com.itextpdf.text.pdf.draw.LineSeparator;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ExperienceCertificates {

    private static String safe(String input) {
        return input == null || input.trim().isEmpty() ? "" : input.trim();
    }

    /**
     * Generates a visually attractive experience certificate PDF in portrait orientation
     */
    public static ByteArrayInputStream generateCertificate(
            HttpServletRequest request, 
            HttpServletResponse response,
            String name, 
            String employeeId, 
            String designation, 
            String joinDate, 
            String releaseDate,
            String department, 
            String email, 
            String projectsWorked, 
            String skills,
            String performance, 
            String certificateType, 
            String remarks) throws IOException {

        // Set response content type
        response.setContentType("application/pdf");
        
        // Create enhanced font objects for better typography
        Font titleRedFont = new Font(Font.FontFamily.COURIER, 14f, Font.BOLD, new BaseColor(153, 0, 0));
        Font blueFont = new Font(Font.FontFamily.COURIER, 11f, Font.BOLD, new BaseColor(0, 51, 102));
        Font normalFont = new Font(Font.FontFamily.COURIER, 12f, Font.NORMAL, BaseColor.BLACK);
        Font normalBoldFont = new Font(Font.FontFamily.COURIER, 12f, Font.BOLD, BaseColor.BLACK);
        Font smallFont = new Font(Font.FontFamily.COURIER, 10f, Font.NORMAL, BaseColor.BLACK);
        Font smallItalicFont = new Font(Font.FontFamily.COURIER, 10f, Font.ITALIC, BaseColor.DARK_GRAY);
        Font titleFont = new Font(Font.FontFamily.COURIER, 20f, Font.BOLD, new BaseColor(0, 51, 102));
        Font dateFont = new Font(Font.FontFamily.COURIER, 12f, Font.ITALIC, new BaseColor(102, 102, 102));

        ByteArrayOutputStream out = new ByteArrayOutputStream();
        Document document = new Document();

        try {
            // Set up document - Portrait orientation with improved margins
            document.setPageSize(PageSize.A4);
            document.setMargins(50, 50, 60, 60);
            PdfWriter writer = PdfWriter.getInstance(document, out);
            
            // Add event handler for page decoration
            writer.setPageEvent(new CertificatePageEvent());
            
            document.open();

            // Calculate employment duration
            String duration = calculateDuration(joinDate, releaseDate);
            
            // Format dates for display
            SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd");
            SimpleDateFormat displayFormat = new SimpleDateFormat("MMMM dd, yyyy");
            
            String displayJoinDate;
            String displayReleaseDate;
            
            try {
                Date startDate = inputFormat.parse(safe(joinDate));
                Date endDate = inputFormat.parse(safe(releaseDate));
                
                displayJoinDate = displayFormat.format(startDate);
                displayReleaseDate = displayFormat.format(endDate);
            } catch (ParseException e) {
                // Fallback to original strings if parsing fails
                displayJoinDate = safe(joinDate);
                displayReleaseDate = safe(releaseDate);
            }
            
            // Current date for certificate
            String today = displayFormat.format(new Date());
            
            // Create logo placeholder (can be replaced with actual logo)
            PdfPTable logoTable = new PdfPTable(3);
            logoTable.setWidthPercentage(100);
            logoTable.setWidths(new float[] {1, 1, 1});
            
            // Left column - empty for now (could be used for logo)
            PdfPCell logoCell = new PdfPCell();
            logoCell.setBorder(Rectangle.NO_BORDER);
            logoCell.setPaddingBottom(10);
            // Uncomment below if you have a logo
            /*
            Image logo = Image.getInstance("path/to/logo.png");
            logo.scaleToFit(80, 80);
            logoCell.addElement(logo);
            */
            logoTable.addCell(logoCell);
            
            // Middle column - certificate number
            PdfPCell certNumCell = new PdfPCell();
            certNumCell.setBorder(Rectangle.NO_BORDER);
            certNumCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            certNumCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            certNumCell.addElement(new Paragraph("Certificate No: CERT-" + safe(employeeId) + "-" + new SimpleDateFormat("yyyyMMdd").format(new Date()), blueFont));
            logoTable.addCell(certNumCell);
            
//            // Right column - date
//            PdfPCell dateTopCell = new PdfPCell();
//            dateTopCell.setBorder(Rectangle.NO_BORDER);
//            dateTopCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
//            dateTopCell.addElement(new Paragraph("Date: " + today, dateFont));
//            logoTable.addCell(dateTopCell);
            
            document.add(logoTable);
            
            // Header with improved aesthetic
            PdfPTable headerTable = new PdfPTable(2);
            headerTable.setWidthPercentage(100);
            
            // Company name in red on left (larger and more prominent)
            PdfPCell leftCell1 = new PdfPCell(new Phrase("SUSEENDRAN V", titleRedFont));
            leftCell1.setBorder(Rectangle.NO_BORDER);
            leftCell1.setHorizontalAlignment(Element.ALIGN_LEFT);
            leftCell1.setPaddingBottom(5);
            headerTable.addCell(leftCell1);
            
            // TC number on right
            PdfPCell rightCell1 = new PdfPCell(new Phrase("TC 32/387", blueFont));
            rightCell1.setBorder(Rectangle.NO_BORDER);
            rightCell1.setHorizontalAlignment(Element.ALIGN_RIGHT);
            rightCell1.setPaddingBottom(5);
            headerTable.addCell(rightCell1);
            
            // CONTRACTOR on left
            PdfPCell leftCell2 = new PdfPCell(new Phrase("CONTRACTOR", blueFont));
            leftCell2.setBorder(Rectangle.NO_BORDER);
            leftCell2.setHorizontalAlignment(Element.ALIGN_LEFT);
            leftCell2.setPaddingBottom(3);
            headerTable.addCell(leftCell2);
            
            // MATHA GREEN GARDENS on right
            PdfPCell rightCell2 = new PdfPCell(new Phrase("THYVILAKOM HOUSE ", blueFont));
            rightCell2.setBorder(Rectangle.NO_BORDER);
            rightCell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
            rightCell2.setPaddingBottom(3);
            headerTable.addCell(rightCell2);
            
            // TRAVANCORE TITANIUM PRODUCTS LTD on left
            PdfPCell leftCell3 = new PdfPCell(new Phrase("TRAVANCORE TITANIUM PRODUCTS LTD,", blueFont));
            leftCell3.setBorder(Rectangle.NO_BORDER);
            leftCell3.setHorizontalAlignment(Element.ALIGN_LEFT);
            leftCell3.setPaddingBottom(3);
            headerTable.addCell(leftCell3);
            
            // KOCHUVELI, KARIKKAKOM P.O on right
            PdfPCell rightCell3 = new PdfPCell(new Phrase("KOCHUVELI, KARIKKAKOM P.O", blueFont));
            rightCell3.setBorder(Rectangle.NO_BORDER);
            rightCell3.setHorizontalAlignment(Element.ALIGN_RIGHT);
            rightCell3.setPaddingBottom(3);
            headerTable.addCell(rightCell3);
            
            // TRIVANDRUM-21 on left
            PdfPCell leftCell4 = new PdfPCell(new Phrase("TRIVANDRUM-21", blueFont));
            leftCell4.setBorder(Rectangle.NO_BORDER);
            leftCell4.setHorizontalAlignment(Element.ALIGN_LEFT);
            leftCell4.setPaddingBottom(3);
            headerTable.addCell(leftCell4);
            
            // TRIVANDRUM -695021 on right
            PdfPCell rightCell4 = new PdfPCell(new Phrase("TRIVANDRUM -695021", blueFont));
            rightCell4.setBorder(Rectangle.NO_BORDER);
            rightCell4.setHorizontalAlignment(Element.ALIGN_RIGHT);
            rightCell4.setPaddingBottom(3);
            headerTable.addCell(rightCell4);
            
            // GST No on left
            PdfPCell leftCell5 = new PdfPCell(new Phrase("GST No: 32AJCPA6156GIZQ", blueFont));
            leftCell5.setBorder(Rectangle.NO_BORDER);
            leftCell5.setHorizontalAlignment(Element.ALIGN_LEFT);
            leftCell5.setPaddingBottom(3);
            headerTable.addCell(leftCell5);
            
            // Mob on right
            PdfPCell rightCell5 = new PdfPCell(new Phrase("Mob: +91 8139097172", blueFont));
            rightCell5.setBorder(Rectangle.NO_BORDER);
            rightCell5.setHorizontalAlignment(Element.ALIGN_RIGHT);
            rightCell5.setPaddingBottom(3);
            headerTable.addCell(rightCell5);
            
            document.add(headerTable);
            
            
            LineSeparator blueLine = new LineSeparator();
            blueLine.setLineColor(new BaseColor(0, 51, 102));
            blueLine.setLineWidth(1);
            blueLine.setPercentage(100);
            document.add(new Chunk(blueLine));
            
            // Title with elegant styling
            document.add(new Paragraph(" "));
            String titleText = determineCertificateTitle(certificateType);
            Paragraph titlePara = new Paragraph(titleText, titleFont);
            titlePara.setAlignment(Element.ALIGN_CENTER);
            titlePara.setSpacingBefore(15);
            titlePara.setSpacingAfter(25);
            document.add(titlePara);

            // Reference number formatted nicely
            String refNumber = "Ref: TCO/" + safe(employeeId) + "/" + new SimpleDateFormat("yyyyMMdd").format(new Date());
            Paragraph refPara = new Paragraph(refNumber, normalFont);
            refPara.setAlignment(Element.ALIGN_RIGHT);
            refPara.setSpacingAfter(20);
            document.add(refPara);

            // Certificate content with improved formatting
            generateCertificateContent(document, 
                safe(certificateType), 
                safe(name), 
                safe(employeeId), 
                safe(designation), 
                safe(department),
                displayJoinDate, 
                displayReleaseDate, 
                duration, 
                safe(email), 
                safe(projectsWorked), 
                safe(skills),
                safe(performance), 
                safe(remarks), 
                normalFont, 
                normalBoldFont, 
                smallFont);

            // Add elegant seal/stamp placeholder (optional)
            /*
            Image sealImage = Image.getInstance("path/to/seal.png");
            sealImage.setAbsolutePosition(100, 200);
            sealImage.scaleToFit(120, 120);
            sealImage.setAlignment(Image.ALIGN_LEFT);
            document.add(sealImage);
            */

            // Signature section with professional layout
            document.add(new Paragraph("\n\n"));
            
            PdfPTable signatureTable = new PdfPTable(2);
            signatureTable.setWidthPercentage(100);
            
         // Left column for company seal/stamp
            PdfPCell leftSigCell = new PdfPCell();
            leftSigCell.setBorder(Rectangle.NO_BORDER);

            // Create paragraph
            Paragraph sealPara = new Paragraph();
            sealPara.setAlignment(Element.ALIGN_LEFT);

            // Add "Seal" text
            sealPara.add(new Chunk("Seal", smallItalicFont));

            // Add space for seal
            sealPara.add(new Chunk("\n\n\n", normalFont));

            // Add "Date :" label
            sealPara.add(new Chunk("Date: ", normalBoldFont));

            // Get current date
            String currentDate = new SimpleDateFormat("dd-MM-yyyy").format(new Date());

            // Add current date
            sealPara.add(new Chunk(currentDate, normalFont));

            // Add paragraph to cell
            leftSigCell.addElement(sealPara);

            // Add cell to table
            signatureTable.addCell(leftSigCell);

            
         // Right column for seal/stamp and signature combined
            PdfPCell rightCell = new PdfPCell();
            rightCell.setBorder(Rectangle.NO_BORDER);

            // Create a paragraph for the combined content
            Paragraph combinedPara = new Paragraph();
            combinedPara.setAlignment(Element.ALIGN_RIGHT);

            // Add name
            combinedPara.add(new Chunk("SUSEENDRAN V", normalBoldFont));

            // Add space for signature
            combinedPara.add(new Chunk("\n\n\n", normalFont));

            // Add contractor label
            combinedPara.add(new Chunk("CONTRACTOR", normalBoldFont));

            // Add paragraph to the cell
            rightCell.addElement(combinedPara);

            // Add the cell to the table
            signatureTable.addCell(rightCell);


            
            document.add(signatureTable);

            // Footer with decorative elements
            document.add(new Paragraph("\n"));
            
            // Add decorative line for footer
            LineSeparator footerLine = new LineSeparator();
            footerLine.setLineColor(new BaseColor(200, 200, 200));
            footerLine.setLineWidth(0.5f);
            footerLine.setPercentage(80);
            
            Paragraph lineParagraph = new Paragraph();
            lineParagraph.setAlignment(Element.ALIGN_CENTER);
            lineParagraph.add(new Chunk(footerLine));
            document.add(lineParagraph);
            
            Paragraph footerPara = new Paragraph(
                "This certificate is issued upon the request of the employee and is valid as of the date mentioned above.", 
                smallItalicFont);
            footerPara.setAlignment(Element.ALIGN_CENTER);
            footerPara.setSpacingBefore(10);
            document.add(footerPara);

            document.close();
        } catch (DocumentException exc) {
            throw new IOException("Error generating certificate: " + exc.getMessage());
        }

        return new ByteArrayInputStream(out.toByteArray());
    }

    // Enhanced page event handler for professional certificate design
    static class CertificatePageEvent extends PdfPageEventHelper {
        @Override
        public void onEndPage(PdfWriter writer, Document document) {
            try {
                PdfContentByte canvas = writer.getDirectContent();
                Rectangle rect = document.getPageSize();
                
                // Create an elegant certificate border with double line effect
                // Outer border
                canvas.setColorStroke(new BaseColor(0, 51, 102));
                canvas.setLineWidth(2f);
                canvas.rectangle(
                    rect.getLeft() + 15,
                    rect.getBottom() + 15,
                    rect.getWidth() - 30,
                    rect.getHeight() - 30
                );
                canvas.stroke();
                
                // Inner border
                canvas.setColorStroke(new BaseColor(153, 0, 0));
                canvas.setLineWidth(1f);
                canvas.rectangle(
                    rect.getLeft() + 20,
                    rect.getBottom() + 20,
                    rect.getWidth() - 40,
                    rect.getHeight() - 40
                );
                canvas.stroke();
                
                // Add corner decorations for elegant certificate look
                float cornerSize = 15;
                
                // Top-left corner
                drawCornerDecoration(canvas, rect.getLeft() + 20, rect.getTop() - 20, cornerSize, 0);
                
                // Top-right corner
                drawCornerDecoration(canvas, rect.getRight() - 20, rect.getTop() - 20, cornerSize, 1);
                
                // Bottom-left corner
                drawCornerDecoration(canvas, rect.getLeft() + 20, rect.getBottom() + 20, cornerSize, 2);
                
                // Bottom-right corner
                drawCornerDecoration(canvas, rect.getRight() - 20, rect.getBottom() + 20, cornerSize, 3);
                
                // Optional watermark for authenticity
                canvas.saveState();
                PdfGState gstate = new PdfGState();
                gstate.setFillOpacity(0.08f);
                canvas.setGState(gstate);
                
                BaseFont bf = BaseFont.createFont(BaseFont.HELVETICA_BOLD, BaseFont.WINANSI, BaseFont.EMBEDDED);
                canvas.beginText();
                canvas.setFontAndSize(bf, 60);
                canvas.setColorFill(new BaseColor(200, 200, 200));
                canvas.showTextAligned(Element.ALIGN_CENTER, "ORIGINAL", rect.getWidth() / 2, rect.getHeight() / 2, 45);
                canvas.endText();
                canvas.restoreState();
                
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        // Draw decorative corner elements
        private void drawCornerDecoration(PdfContentByte canvas, float x, float y, float size, int position) {
            canvas.setColorStroke(new BaseColor(0, 0, 0));
            canvas.setLineWidth(0.5f);
            
            switch (position) {
                case 0: // Top-left
                    canvas.moveTo(x, y - size);
                    canvas.lineTo(x, y);
                    canvas.lineTo(x + size, y);
                    break;
                case 1: // Top-right
                    canvas.moveTo(x, y);
                    canvas.lineTo(x - size, y);
                    canvas.moveTo(x, y);
                    canvas.lineTo(x, y - size);
                    break;
                case 2: // Bottom-left
                    canvas.moveTo(x, y);
                    canvas.lineTo(x, y + size);
                    canvas.moveTo(x, y);
                    canvas.lineTo(x + size, y);
                    break;
                case 3: // Bottom-right
                    canvas.moveTo(x, y);
                    canvas.lineTo(x - size, y);
                    canvas.moveTo(x, y);
                    canvas.lineTo(x, y + size);
                    break;
            }
            canvas.stroke();
        }
    }

    // Calculate employment duration method
    private static String calculateDuration(String joinDateStr, String releaseDateStr) {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date startDate = sdf.parse(safe(joinDateStr));
            Date endDate = sdf.parse(safe(releaseDateStr));

            long diffInMillis = Math.abs(endDate.getTime() - startDate.getTime());
            long diffInDays = diffInMillis / (24 * 60 * 60 * 1000);

            int years = (int) (diffInDays / 365);
            int months = (int) ((diffInDays % 365) / 30);
            int days = (int) ((diffInDays % 365) % 30);

            StringBuilder duration = new StringBuilder();
            
            if (years > 0) {
                duration.append(years).append(" year");
                if (years > 1) duration.append("s");
            }
            
            if (months > 0) {
                if (duration.length() > 0) duration.append(", ");
                duration.append(months).append(" month");
                if (months > 1) duration.append("s");
            }
            
            if (days > 0 && (years == 0 && months == 0)) {
                if (duration.length() > 0) duration.append(" and ");
                duration.append(days).append(" day");
                if (days > 1) duration.append("s");
            }
            
            return duration.toString();
        } catch (ParseException e) {
            return ""; // Return empty string if dates cannot be parsed
        }
    }

    // Determine appropriate certificate title
    private static String determineCertificateTitle(String certificateType) {
        switch (safe(certificateType).toLowerCase()) {
            case "recommendation":
                return "LETTER OF RECOMMENDATION";
            case "detailed":
                return "DETAILED EXPERIENCE CERTIFICATE";
            case "standard":
            default:
                return "EXPERIENCE CERTIFICATE";
        }
    }

    // Generate certificate content with improved formatting
    private static void generateCertificateContent(
            Document document, 
            String certificateType, 
            String name, 
            String employeeId,
            String designation, 
            String department, 
            String joinDate, 
            String releaseDate, 
            String duration,
            String email, 
            String projectsWorked, 
            String skills, 
            String performance, 
            String remarks,
            Font fontBody, 
            Font fontBodyBold, 
            Font fontSmall) throws DocumentException {
            
        Paragraph para = new Paragraph();
        para.setAlignment(Element.ALIGN_JUSTIFIED);
        para.setLeading(0, 1.5f);  // Improved line spacing for better readability

        switch (certificateType.toLowerCase()) {
            case "standard":
                // Add decorative initial capital effect
                Font largeInitialFont = new Font(Font.FontFamily.HELVETICA, 16f, Font.BOLD, new BaseColor(0, 51, 102));
                Chunk initialT = new Chunk("T", largeInitialFont);
                para.add(initialT);
                
                para.add(new Phrase("his is to certify that ", fontBody));
                para.add(new Phrase(name + " ", fontBodyBold));
                para.add(new Phrase("was employed as a ", fontBody));
                para.add(new Phrase(designation + " ", fontBodyBold));
                para.add(new Phrase("in the ", fontBody));
                para.add(new Phrase(department + " ", fontBodyBold));
                para.add(new Phrase("department from ", fontBody));
                para.add(new Phrase(joinDate + " ", fontBodyBold));
                para.add(new Phrase("to ", fontBody));
                para.add(new Phrase(releaseDate + ".", fontBodyBold));
                para.add(new Phrase(" The total duration of employment was ", fontBody));
                para.add(new Phrase(duration + ".", fontBodyBold));
                
                para.add(new Phrase("\n\nDuring this period, the employee's performance was ", fontBody));
                para.add(new Phrase(performance + ".", fontBodyBold));
                
                if (!remarks.isEmpty()) {
                    para.add(new Phrase("\n\n" + remarks, fontBody));
                }
                break;

            case "detailed":
                // Create a structured, professional detailed certificate
                para.add(new Phrase("This is to certify that ", fontBody));
                para.add(new Phrase(name + " ", fontBodyBold));
                para.add(new Phrase("(Employee ID: " + employeeId + ") ", fontBody));
                para.add(new Phrase("worked as a ", fontBody));
                para.add(new Phrase(designation + " ", fontBodyBold));
                para.add(new Phrase("in the ", fontBody));
                para.add(new Phrase(department + " ", fontBodyBold));
                para.add(new Phrase("department from ", fontBody));
                para.add(new Phrase(joinDate + " ", fontBodyBold));
                para.add(new Phrase("to ", fontBody));
                para.add(new Phrase(releaseDate + ".", fontBodyBold));
                
                document.add(para);
                
                // Create a styled table for detailed information
                PdfPTable detailsTable = new PdfPTable(2);
                detailsTable.setWidthPercentage(90);
                detailsTable.setSpacingBefore(20);
                detailsTable.setSpacingAfter(20);
                try {
                    detailsTable.setWidths(new float[]{1, 3});
                } catch (DocumentException e) {
                    e.printStackTrace();
                }
                
                // Add section headers and content as table rows
                Font headerFont = new Font(Font.FontFamily.HELVETICA, 12f, Font.BOLD, new BaseColor(0, 51, 102));
                
                // Duration row
                PdfPCell headerCell1 = new PdfPCell(new Phrase("Duration", headerFont));
                headerCell1.setBorderColor(new BaseColor(220, 220, 220));
                headerCell1.setPadding(8);
                headerCell1.setBackgroundColor(new BaseColor(245, 245, 250));
                detailsTable.addCell(headerCell1);
                
                PdfPCell valueCell1 = new PdfPCell(new Phrase(duration, fontBody));
                valueCell1.setBorderColor(new BaseColor(220, 220, 220));
                valueCell1.setPadding(8);
                detailsTable.addCell(valueCell1);
                
                // Projects row
                PdfPCell headerCell2 = new PdfPCell(new Phrase("Projects", headerFont));
                headerCell2.setBorderColor(new BaseColor(220, 220, 220));
                headerCell2.setPadding(8);
                headerCell2.setBackgroundColor(new BaseColor(245, 245, 250));
                detailsTable.addCell(headerCell2);
                
                PdfPCell valueCell2 = new PdfPCell(new Phrase(projectsWorked, fontBody));
                valueCell2.setBorderColor(new BaseColor(220, 220, 220));
                valueCell2.setPadding(8);
                detailsTable.addCell(valueCell2);
                
                // Skills row
                PdfPCell headerCell3 = new PdfPCell(new Phrase("Skills", headerFont));
                headerCell3.setBorderColor(new BaseColor(220, 220, 220));
                headerCell3.setPadding(8);
                headerCell3.setBackgroundColor(new BaseColor(245, 245, 250));
                detailsTable.addCell(headerCell3);
                
                PdfPCell valueCell3 = new PdfPCell(new Phrase(skills, fontBody));
                valueCell3.setBorderColor(new BaseColor(220, 220, 220));
                valueCell3.setPadding(8);
                detailsTable.addCell(valueCell3);
                
                // Performance row
                PdfPCell headerCell4 = new PdfPCell(new Phrase("Performance", headerFont));
                headerCell4.setBorderColor(new BaseColor(220, 220, 220));
                headerCell4.setPadding(8);
                headerCell4.setBackgroundColor(new BaseColor(245, 245, 250));
                detailsTable.addCell(headerCell4);
                
                PdfPCell valueCell4 = new PdfPCell(new Phrase(performance, fontBody));
                valueCell4.setBorderColor(new BaseColor(220, 220, 220));
                valueCell4.setPadding(8);
                detailsTable.addCell(valueCell4);
                
                // Contact row
                PdfPCell headerCell5 = new PdfPCell(new Phrase("Contact", headerFont));
                headerCell5.setBorderColor(new BaseColor(220, 220, 220));
                headerCell5.setPadding(8);
                headerCell5.setBackgroundColor(new BaseColor(245, 245, 250));
                detailsTable.addCell(headerCell5);
                
                PdfPCell valueCell5 = new PdfPCell(new Phrase(email, fontBody));
                valueCell5.setBorderColor(new BaseColor(220, 220, 220));
                valueCell5.setPadding(8);
                detailsTable.addCell(valueCell5);
                
                // Remarks row (if provided)
                if (!remarks.isEmpty()) {
                    PdfPCell headerCell6 = new PdfPCell(new Phrase("Remarks", headerFont));
                    headerCell6.setBorderColor(new BaseColor(220, 220, 220));
                    headerCell6.setPadding(8);
                    headerCell6.setBackgroundColor(new BaseColor(245, 245, 250));
                    detailsTable.addCell(headerCell6);
                    
                    PdfPCell valueCell6 = new PdfPCell(new Phrase(remarks, fontBody));
                    valueCell6.setBorderColor(new BaseColor(220, 220, 220));
                    valueCell6.setPadding(8);
                    detailsTable.addCell(valueCell6);
                }
                
                document.add(detailsTable);
                
                // Closing statement
                Paragraph closingPara = new Paragraph(
                    "We wish " + name + " all the best for future endeavors.", 
                    fontBody);
                closingPara.setAlignment(Element.ALIGN_JUSTIFIED);
                document.add(closingPara);
                
                // Return early as we've already added paragraphs to document
                return;

            case "recommendation":
                // Create an elegant recommendation letter
                Font largeCapital = new Font(Font.FontFamily.HELVETICA, 16f, Font.BOLD, new BaseColor(0, 51, 102));
                Chunk initialCapital = new Chunk("T", largeCapital);
                para.add(initialCapital);
                
                para.add(new Phrase("o Whom It May Concern,", fontBodyBold));
                
                para.add(new Phrase("\n\nI am pleased to recommend ", fontBody));
                para.add(new Phrase(name + ", ", fontBodyBold));
                para.add(new Phrase("who served as a ", fontBody));
                para.add(new Phrase(designation + " ", fontBodyBold));
                para.add(new Phrase("in the ", fontBody));
                para.add(new Phrase(department + " ", fontBodyBold));
                para.add(new Phrase("department from ", fontBody));
                para.add(new Phrase(joinDate + " ", fontBodyBold));
                para.add(new Phrase("to ", fontBody));
                para.add(new Phrase(releaseDate + ".", fontBodyBold));
                
                para.add(new Phrase("\n\nDuring " + duration + " of employment, ", fontBody));
                para.add(new Phrase(name, fontBodyBold));
                para.add(new Phrase(" contributed significantly to ", fontBody));
                
                if (!projectsWorked.isEmpty()) {
                    para.add(new Phrase("projects including " + projectsWorked + ", ", fontBody));
                }
                
                if (!skills.isEmpty()) {
                    para.add(new Phrase("demonstrating expertise in " + skills + ". ", fontBody));
                }
                
                para.add(new Phrase("\n\nIn terms of performance, ", fontBody));
                para.add(new Phrase(name + " ", fontBodyBold));
                para.add(new Phrase("consistently demonstrated " + performance + " work quality. ", fontBody));
                
                if (!remarks.isEmpty()) {
                    para.add(new Phrase(remarks + " ", fontBody));
                }
                
                para.add(new Phrase("\n\nI am confident that ", fontBody));
                para.add(new Phrase(name, fontBodyBold));
                para.add(new Phrase(" will be a valuable asset to any organization. I highly recommend " + 
                    name + " for any suitable position matching their skill set and experience.", fontBody));
                
                para.add(new Phrase("\n\nPlease feel free to contact me for any further information.", fontBody));
                break;
                
            default:
                // Standard certificate as a fallback
                para.add(new Phrase("This is to certify that ", fontBody));
                para.add(new Phrase(name + " ", fontBodyBold));
                para.add(new Phrase("worked as a ", fontBody));
                para.add(new Phrase(designation + " ", fontBodyBold));
                para.add(new Phrase("from ", fontBody));
                para.add(new Phrase(joinDate + " ", fontBodyBold));
                para.add(new Phrase("to ", fontBody));
                para.add(new Phrase(releaseDate + ".", fontBodyBold));
                
                if (!performance.isEmpty()) {
                    para.add(new Phrase(" Performance during this period was ", fontBody));
                    para.add(new Phrase(performance + ".", fontBodyBold));
                }
                
                if (!remarks.isEmpty()) {
                    para.add(new Phrase("\n\n" + remarks, fontBody));
                }
                break;
        }
        
        document.add(para);
    }
}