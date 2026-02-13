import Link from 'next/link';
import { brand } from '@/lib/brand';

interface BrandFooterProps {
  locale?: 'fa' | 'en';
}

export default function BrandFooter({ locale = 'en' }: BrandFooterProps) {
  const text = locale === 'fa' ? brand.footerTextFa : brand.footerTextEn;

  return (
    <footer className="border-t">
      <div className="container mx-auto px-4 py-3 text-center text-xs text-muted-foreground">
        <Link href={brand.engineeringHubUrl} target="_blank" rel="noopener noreferrer" className="underline">
          {text}
        </Link>
      </div>
    </footer>
  );
}

